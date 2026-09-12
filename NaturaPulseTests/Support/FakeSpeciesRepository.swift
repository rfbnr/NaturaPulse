//
//  FakeSpeciesRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
@testable import NaturaPulse

final class FakeSpeciesRepository: SpeciesRepository {
    var nearbyResult: Result<[Species], AppError> = .success([])
    var searchResult: Result<[Species], AppError> = .success([])
    var profileID: Int?
    var profileResult: Result<SpeciesProfile, AppError> = .success(SpeciesProfile(summary: nil, summarySource: nil))

    var nearbyPublisher: AnyPublisher<[Species], AppError>?
    private(set) var nearbyCallCount = 0

    var searchQuery: String?
    var searchCallCount = 0

    var searchHandler: ((String) -> AnyPublisher<[Species], AppError>)?

    func getNearbySpecies(
        at location: Location,
        radius: Distance
    ) -> AnyPublisher<[Species], AppError> {
        nearbyCallCount += 1
        if let nearbyPublisher {
            return nearbyPublisher
        }
        return nearbyResult.publisher.eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        searchCallCount += 1
        searchQuery = query
        if let searchHandler {
            return searchHandler(query)
        }
        return searchResult.publisher.eraseToAnyPublisher()
    }

    func getSpeciesProfile(id: Species.ID) -> AnyPublisher<SpeciesProfile, AppError> {
        profileID = id
        return profileResult.publisher.eraseToAnyPublisher()
    }
}
