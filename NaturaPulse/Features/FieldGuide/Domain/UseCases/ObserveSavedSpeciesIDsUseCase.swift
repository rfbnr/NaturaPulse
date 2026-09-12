//
//  ObserveSavedSpeciesIDsUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import Combine

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
