//
//  SpeciesRepositoryImpl.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

final class SpeciesRepositoryImpl: SpeciesRepository {
    private let dataSource: GBIFRemoteDataSource
    private let defaultLimit = 20

    init(dataSource: GBIFRemoteDataSource) {
        self.dataSource = dataSource
    }

    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        dataSource
            .nearby(latitude: location.latitude, longitude: location.longitude, radiusKm: Int(radius.kilometers.rounded()), limit: defaultLimit)
            .map { SpeciesMapper.map($0.results) }
            .mapError { $0.toAppError() }
            .eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        dataSource
            .search(query: query, limit: defaultLimit)
            .map { SpeciesMapper.map($0.results) }
            .mapError { $0.toAppError() }
            .eraseToAnyPublisher()
    }

    func getSpeciesDetail(id: Species.ID) -> AnyPublisher<Species, AppError> {
        dataSource
            .occurrence(id: id)
            .map { SpeciesMapper.map([$0]) }
            .tryMap { species -> Species in
                guard let first = species.first else { throw AppError.notFound }
                return first
            }
            .mapError { error -> AppError in
                if let appError = error as? AppError { return appError }
                if let networkError = error as? NetworkError { return networkError.toAppError() }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
