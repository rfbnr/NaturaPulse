//
//  FakeSpeciesRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common

public final class FakeSpeciesRepository: SpeciesRepository {
    public var nearbyResult: Result<[Species], AppError> = .success([])
    public var searchResult: Result<[Species], AppError> = .success([])
    public var profileID: Int?
    public var profileResult: Result<SpeciesProfile, AppError> = .success(SpeciesProfile(summary: nil, summarySource: nil))

    public var nearbyPublisher: AnyPublisher<[Species], AppError>?
    public private(set) var nearbyCallCount = 0

    public var searchQuery: String?
    public var searchCallCount = 0

    public var searchHandler: ((String) -> AnyPublisher<[Species], AppError>)?

    public init() {}

    public func getNearbySpecies(
        at location: Location,
        radius: Distance
    ) -> AnyPublisher<[Species], AppError> {
        nearbyCallCount += 1
        if let nearbyPublisher {
            return nearbyPublisher
        }
        return nearbyResult.publisher.eraseToAnyPublisher()
    }

    public func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        searchCallCount += 1
        searchQuery = query
        if let searchHandler {
            return searchHandler(query)
        }
        return searchResult.publisher.eraseToAnyPublisher()
    }

    public func getSpeciesProfile(id: Species.ID) -> AnyPublisher<SpeciesProfile, AppError> {
        profileID = id
        return profileResult.publisher.eraseToAnyPublisher()
    }
}
