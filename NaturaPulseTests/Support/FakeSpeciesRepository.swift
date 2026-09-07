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
    var detailResult: Result<Species, AppError> = .success(.stub())

    /// When set, returned in place of `nearbyResult.publisher` — lets a test
    /// control the timing of a `getNearbySpecies` call (e.g. with a
    /// `PassthroughSubject`) instead of resolving synchronously.
    var nearbyPublisher: AnyPublisher<[Species], AppError>?
    private(set) var nearbyCallCount = 0

    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        nearbyCallCount += 1
        if let nearbyPublisher {
            return nearbyPublisher
        }
        return nearbyResult.publisher.eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        searchResult.publisher.eraseToAnyPublisher()
    }

    func getSpeciesDetail(id: Species.ID) -> AnyPublisher<Species, AppError> {
        detailResult.publisher.eraseToAnyPublisher()
    }
}
