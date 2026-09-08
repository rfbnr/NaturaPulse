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

    func getSpeciesProfile(id: Species.ID) -> AnyPublisher<SpeciesProfile, AppError> {
        dataSource
            .speciesDescriptions(speciesKey: id)
            .map { SpeciesProfileMapper.map($0) }
            .mapError { $0.toAppError() }
            .eraseToAnyPublisher()
    }
}
