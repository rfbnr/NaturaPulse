//
//  FakeLocationRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
@testable import Common

final class FakeLocationRepository: LocationRepository {
    var result: Result<[Location], AppError> = .success([])

    func searchLocations(
        query: String
    ) -> AnyPublisher<[Location], AppError> {
        result.publisher.eraseToAnyPublisher()
    }
}
