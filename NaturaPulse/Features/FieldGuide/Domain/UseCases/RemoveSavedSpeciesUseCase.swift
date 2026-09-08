//
//  RemoveSavedSpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct RemoveSavedSpeciesUseCase {
    private let repository: FieldGuideRepository

    init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Species.ID) -> AnyPublisher<Void, AppError> {
        repository.remove(id: id)
    }
}
