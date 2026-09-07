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

    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        nearbyResult.publisher.eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        searchResult.publisher.eraseToAnyPublisher()
    }

    func getSpeciesDetail(id: Species.ID) -> AnyPublisher<Species, AppError> {
        detailResult.publisher.eraseToAnyPublisher()
    }
}
