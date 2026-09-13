//
//  GetNearbySpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public struct GetNearbySpeciesUseCase {
    private let repository: SpeciesRepository

    public init(repository: SpeciesRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        location: Location,
        radius: Distance
    ) -> AnyPublisher<[Species], AppError> {
        repository.getNearbySpecies(at: location, radius: radius)
    }
}
