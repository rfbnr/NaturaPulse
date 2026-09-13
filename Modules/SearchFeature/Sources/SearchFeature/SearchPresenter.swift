//
//  SearchPresenter.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common
import Foundation
import Observation

@Observable
@MainActor
public final class SearchPresenter {
    var query: String = "" {
        didSet { querySubject.send(query) }
    }
    private(set) var state: LoadState<[Species]> = .idle
    private(set) var savedIDs: Set<Species.ID> = []
    var path: [AppRoute] = []

    @ObservationIgnored private let searchSpecies: SearchSpeciesUseCase
    @ObservationIgnored private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    @ObservationIgnored private let querySubject = PassthroughSubject<String, Never>()
    @ObservationIgnored private let retrySubject = PassthroughSubject<String, Never>()
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    @ObservationIgnored private var toggleCancellable: AnyCancellable?

    public init(
        searchSpecies: SearchSpeciesUseCase,
        toggleFavorite: ToggleFavoriteUseCase,
        observeSavedIDs: ObserveSavedSpeciesIDsUseCase,
        debounceInterval: DispatchQueue.SchedulerTimeType.Stride = .milliseconds(300),
        scheduler: DispatchQueue = .main
    ) {
        self.searchSpecies = searchSpecies
        self.toggleFavoriteUseCase = toggleFavorite

        let debouncedQueries = querySubject
            .debounce(for: debounceInterval, scheduler: scheduler)
            .removeDuplicates()
            .eraseToAnyPublisher()

        Publishers.Merge(debouncedQueries, retrySubject.eraseToAnyPublisher())
            .map { [searchSpecies] rawQuery -> AnyPublisher<SearchOutcome, Never> in
                let trimmed = rawQuery.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard trimmed.count >= 2 else {
                    return Just(SearchOutcome.idle).eraseToAnyPublisher()
                }
                
                return searchSpecies(query: trimmed)
                    .map { SearchOutcome.result($0) }
                    .catch { Just(SearchOutcome.failure($0)) }
                    .prepend(.loading)
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: scheduler)
            .sink { [weak self] outcome in
                self?.apply(outcome)
            }
            .store(in: &cancellables)

        observeSavedIDs()
            .receive(on: scheduler)
            .sink { [weak self] ids in self?.savedIDs = ids }
            .store(in: &cancellables)
    }

    func retry() {
        retrySubject.send(query)
    }

    func select(species: Species) {
        path.append(.speciesDetail(species))
    }

    func isSaved(_ id: Species.ID) -> Bool {
        savedIDs.contains(id)
    }

    func toggleFavorite(_ species: Species) {
        toggleCancellable = toggleFavoriteUseCase(species)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    private func apply(_ outcome: SearchOutcome) {
        switch outcome {
        case .idle:
            state = .idle
        case .loading:
            let previous: [Species]? = {
                if case .loaded(let value) = state { return value } else { return nil }
            }()
            state = .loading(previous: previous)
        case .result(let species):
            state = species.isEmpty ? .empty : .loaded(species)
        case .failure(let error):
            state = .failed(error)
        }
    }
}
