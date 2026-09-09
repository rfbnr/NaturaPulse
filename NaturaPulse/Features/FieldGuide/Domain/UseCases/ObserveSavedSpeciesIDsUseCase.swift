//
//  ObserveSavedSpeciesIDsUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import Combine

/// Observes the set of saved species IDs. Backed by the existing
/// `savedSpecies()` stream so a screen needs only one subscription to
/// render per-card favorite state (O(1) membership check), rather than one
/// `isSaved` subscription per card. Never fails — a persistence error maps
/// to an empty set, consistent with `ObserveIsSavedUseCase` being `Never`.
struct ObserveSavedSpeciesIDsUseCase {
    private let repository: FieldGuideRepository

    init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    func callAsFunction() -> AnyPublisher<Set<Species.ID>, Never> {
        repository.savedSpecies()
            .map { Set($0.map(\.id)) }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
