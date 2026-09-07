//
//  GetSavedSpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct GetSavedSpeciesUseCase {
    private let repository: FieldGuideRepository

    init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    func callAsFunction() -> AnyPublisher<[Species], AppError> {
        repository.savedSpecies()
    }
}
