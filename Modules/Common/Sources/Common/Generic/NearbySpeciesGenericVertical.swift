//
//  NearbySpeciesGenericVertical.swift
//  Common
//
//  Created by Ridwan Febnur AR on 13/09/26.
//

import Combine

public struct NearbySpeciesRequest {
    public let location: Location
    public let radius: Distance

    public init(location: Location, radius: Distance) {
        self.location = location
        self.radius = radius
    }
}

extension GetNearbySpeciesUseCase: UseCase {
    public func execute(_ request: NearbySpeciesRequest) -> AnyPublisher<[Species], AppError> {
        callAsFunction(location: request.location, radius: request.radius)
    }
}

public struct NearbySpeciesRepository: Repository {
    private let source: SpeciesRepository

    public init(source: SpeciesRepository) {
        self.source = source
    }

    public func fetch(_ request: NearbySpeciesRequest) -> AnyPublisher<[Species], AppError> {
        source.getNearbySpecies(at: request.location, radius: request.radius)
    }
}

struct SpeciesListMapper: Mapper {
    func toDomain(_ dto: [GBIFOccurrenceDTO]) -> [Species] {
        SpeciesMapper.map(dto)
    }
}
