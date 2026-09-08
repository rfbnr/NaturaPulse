//
//  GetSpeciesProfileUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct GetSpeciesProfileUseCase {
    private let repository: SpeciesRepository

    init(repository: SpeciesRepository) {
        self.repository = repository
    }

    func callAsFunction(id: Species.ID) -> AnyPublisher<SpeciesProfile, AppError> {
        repository.getSpeciesProfile(id: id)
    }
}
