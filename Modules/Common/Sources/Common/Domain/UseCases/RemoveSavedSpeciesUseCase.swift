//
//  RemoveSavedSpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public struct RemoveSavedSpeciesUseCase {
    private let repository: FieldGuideRepository

    public init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        id: Species.ID
    ) -> AnyPublisher<Void, AppError> {
        repository.remove(id: id)
    }
}
