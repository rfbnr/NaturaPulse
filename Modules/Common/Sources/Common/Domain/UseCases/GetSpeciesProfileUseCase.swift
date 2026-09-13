//
//  GetSpeciesProfileUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public struct GetSpeciesProfileUseCase {
    private let repository: SpeciesRepository

    public init(repository: SpeciesRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        id: Species.ID
    ) -> AnyPublisher<SpeciesProfile, AppError> {
        repository.getSpeciesProfile(id: id)
    }
}
