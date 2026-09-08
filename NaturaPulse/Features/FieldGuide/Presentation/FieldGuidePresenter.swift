//
//  FieldGuidePresenter.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import Observation

@Observable
@MainActor
final class FieldGuidePresenter {
    private(set) var state: LoadState<[Species]> = .idle
    var path: [AppRoute] = []

    @ObservationIgnored private let getSavedSpecies: GetSavedSpeciesUseCase
    @ObservationIgnored private let removeSavedSpecies: RemoveSavedSpeciesUseCase
    @ObservationIgnored private var savedCancellable: AnyCancellable?
    @ObservationIgnored private var removeCancellable: AnyCancellable?

    init(getSavedSpecies: GetSavedSpeciesUseCase, removeSavedSpecies: RemoveSavedSpeciesUseCase) {
        self.getSavedSpecies = getSavedSpecies
        self.removeSavedSpecies = removeSavedSpecies
    }

    func onAppear() {
        guard case .idle = state else { return }
        load()
    }

    func retry() { load() }

    private func load() {
        state = .loading(previous: nil)
        savedCancellable = getSavedSpecies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion { self?.state = .failed(error) }
            }, receiveValue: { [weak self] species in
                self?.state = species.isEmpty ? .empty : .loaded(species)
            })
    }

    func remove(id: Species.ID) {
        removeCancellable = removeSavedSpecies(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    func select(species: Species) {
        path.append(.speciesDetail(species))
    }
}
