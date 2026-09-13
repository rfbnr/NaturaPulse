//
//  GetSavedSpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public struct GetSavedSpeciesUseCase {
    private let repository: FieldGuideRepository

    public init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    public func callAsFunction() -> AnyPublisher<[Species], AppError> {
        repository.savedSpecies()
    }
}
