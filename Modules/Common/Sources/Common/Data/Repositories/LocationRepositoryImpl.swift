//
//  LocationRepositoryImpl.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

final class LocationRepositoryImpl: LocationRepository {
    private let dataSource: GeocodingRemoteDataSource

    init(dataSource: GeocodingRemoteDataSource) {
        self.dataSource = dataSource
    }

    func searchLocations(query: String) -> AnyPublisher<[Location], AppError> {
        dataSource
            .search(name: query)
            .map { LocationMapper.map($0.results ?? []) }
            .mapError { $0.toAppError() }
            .eraseToAnyPublisher()
    }
}
