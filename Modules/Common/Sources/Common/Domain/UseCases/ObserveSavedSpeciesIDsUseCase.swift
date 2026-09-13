//
//  ObserveSavedSpeciesIDsUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import Combine

public struct ObserveSavedSpeciesIDsUseCase {
    private let repository: FieldGuideRepository

    public init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    public func callAsFunction() -> AnyPublisher<Set<Species.ID>, Never> {
        repository.savedSpecies()
            .map { Set($0.map(\.id)) }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
