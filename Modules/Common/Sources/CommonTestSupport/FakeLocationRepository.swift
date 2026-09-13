//
//  FakeLocationRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common

public final class FakeLocationRepository: LocationRepository {
    public var result: Result<[Location], AppError> = .success([])

    public init() {}

    public func searchLocations(
        query: String
    ) -> AnyPublisher<[Location], AppError> {
        result.publisher.eraseToAnyPublisher()
    }
}
