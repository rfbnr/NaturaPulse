//
//  GetNearbySpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct GetNearbySpeciesUseCase {
    private let repository: SpeciesRepository

    init(repository: SpeciesRepository) {
        self.repository = repository
    }

    func callAsFunction(location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        repository.getNearbySpecies(at: location, radius: radius)
    }
}
