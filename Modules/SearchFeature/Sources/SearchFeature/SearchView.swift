//
//  SearchView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common
import Swinject
import SwiftUI

public struct SearchView: View {
    @State var presenter: SearchPresenter
    @Environment(\.resolver) private var resolver

    public init(presenter: SearchPresenter) {
        _presenter = State(initialValue: presenter)
    }

    public var body: some View {
        NavigationStack(path: $presenter.path) {
            content
                .background(AppColor.background)
                .navigationTitle("search.title".localized)
                .searchable(text: $presenter.query, prompt: "search.prompt".localized)
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle:
            EmptyStateView(
                title: "search.idle_title".localized,
                message: "search.idle_message".localized,
                actionTitle: nil,
                action: nil
            )
        case .loading(let previous):
            if let previous {
                resultsList(previous)
                    .opacity(0.6)
            } else {
                ScrollView {
                    LoadingStateView()
                }
            }
        case .loaded(let species):
            resultsList(species)
        case .empty:
            EmptyStateView(
                title: "search.empty_title".localized,
                message: "search.empty_message".localized,
                actionTitle: nil,
                action: nil
            )
        case .failed(let error):
            ErrorStateView(message: error.userMessage, retry: presenter.retry)
        }
    }

    private func resultsList(_ species: [Species]) -> some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                ForEach(species) { item in
                    Button {
                        presenter.select(species: item)
                    } label: {
                        SpeciesCardView(
                            species: item,
                            isSaved: presenter.isSaved(item.id),
                            onToggleFavorite: {
                                let wasSaved = presenter.isSaved(item.id)
                                presenter.toggleFavorite(item)
                                Haptics.favoriteToggle(wasSaved: wasSaved)
                            }
                        )
                    }
                    .buttonStyle(PressableCardStyle())
                    .accessibilityLabel(item.commonName ?? item.scientificName)
                    .accessibilityAction(named: presenter.isSaved(item.id) ? "Remove from Field Guide" : "Add to Field Guide") {
                        let wasSaved = presenter.isSaved(item.id)
                        presenter.toggleFavorite(item)
                        Haptics.favoriteToggle(wasSaved: wasSaved)
                    }
                }
            }
            .padding(AppSpacing.md)
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .speciesDetail(let species):
            resolver.resolveRequired(SpeciesDetailViewProviding.self).makeDetailView(for: species)
        case .locationSearch:
            EmptyView()
        }
    }
}


#if DEBUG
private struct PreviewSpeciesRepository: SpeciesRepository {
    let species: [Species]
    var error: AppError?

    func getNearbySpecies(
        at location: Location,
        radius: Distance
    ) -> AnyPublisher<[Species], AppError> {
        Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func searchSpecies(
        query: String
    ) -> AnyPublisher<[Species], AppError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func getSpeciesProfile(
        id: Species.ID
    ) -> AnyPublisher<SpeciesProfile, AppError> {
        Just(
            SpeciesProfile(summary: nil, summarySource: nil)
        ).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewFieldGuideRepository: FieldGuideRepository {
    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
    func isSaved(
        _ id: Species.ID
    ) -> AnyPublisher<Bool, Never> { Just(false).eraseToAnyPublisher() }
    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private extension SearchPresenter {
    static func preview(
        query: String = "",
        species: [Species],
        error: AppError? = nil
    ) -> SearchPresenter {
        let fieldGuide = PreviewFieldGuideRepository()
        let presenter = SearchPresenter(
            searchSpecies: SearchSpeciesUseCase(
                repository: PreviewSpeciesRepository(species: species, error: error)
            ),
            toggleFavorite: ToggleFavoriteUseCase(repository: fieldGuide),
            observeSavedIDs: ObserveSavedSpeciesIDsUseCase(repository: fieldGuide)
        )
        
        if !query.isEmpty {
            presenter.query = query
        }
        
        return presenter
    }
}

private let previewSpecies: [Species] = [
    Species(
        id: 1,
        scientificName: "Copsychus saularis",
        commonName: "Oriental Magpie Robin",
        kingdom: "Animalia",
        phylum: "Chordata",
        className: "Aves",
        order: "Passeriformes",
        family: "Muscicapidae",
        genus: "Copsychus",
        description: nil,
        image: nil,
        localObservationCount: 3,
        lastObservedAt: nil,
        source: nil
    ),
    Species(
        id: 2,
        scientificName: "Acridotheres javanicus",
        commonName: "Javan Myna",
        kingdom: "Animalia",
        phylum: "Chordata",
        className: "Aves",
        order: "Passeriformes",
        family: "Sturnidae",
        genus: "Acridotheres",
        description: nil,
        image: nil,
        localObservationCount: 7,
        lastObservedAt: nil,
        source: nil
    )
]

#Preview("Idle") {
    SearchView(presenter: .preview(species: []))
}

#Preview("Loaded") {
    SearchView(
        presenter: .preview(query: "myna", species: previewSpecies)
    )
}

#Preview("Empty") {
    SearchView(
        presenter: .preview(query: "zzz", species: [])
    )
}

#Preview("Failed") {
    SearchView(
        presenter: .preview(query: "myna", species: [], error: .networkUnavailable)
    )
}
#endif
