//
//  ExploreUseCaseTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

private final class FakeSpeciesRepo: SpeciesRepository {
    var nearby: Result<[Species], AppError> = .success([])
    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> { nearby.publisher.eraseToAnyPublisher() }
    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> { nearby.publisher.eraseToAnyPublisher() }
    func getSpeciesDetail(id: Species.ID) -> AnyPublisher<Species, AppError> { Fail(error: .notFound).eraseToAnyPublisher() }
}

private final class FakeLocationRepo: LocationRepository {
    var searchCalledWith: String?
    var result: Result<[Location], AppError> = .success([.jakarta])
    func searchLocations(query: String) -> AnyPublisher<[Location], AppError> {
        searchCalledWith = query
        return result.publisher.eraseToAnyPublisher()
    }
}

final class ExploreUseCaseTests: XCTestCase {
    func testNearbyDelegatesToRepository() throws {
        let repo = FakeSpeciesRepo()
        repo.nearby = .success([Species.stub(id: 1)])
        let useCase = GetNearbySpeciesUseCase(repository: repo)
        let result = try awaitPublisher(useCase(location: .jakarta, radius: .km(10)))
        XCTAssertEqual(result.count, 1)
    }

    func testSearchLocationShortQueryReturnsEmptyWithoutCallingRepository() throws {
        let repo = FakeLocationRepo()
        let useCase = SearchLocationUseCase(repository: repo)
        let result = try awaitPublisher(useCase(query: " a "))
        XCTAssertTrue(result.isEmpty)
        XCTAssertNil(repo.searchCalledWith)
    }

    func testSearchLocationTrimsAndDelegates() throws {
        let repo = FakeLocationRepo()
        let useCase = SearchLocationUseCase(repository: repo)
        let result = try awaitPublisher(useCase(query: "  Jakarta  "))
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(repo.searchCalledWith, "Jakarta")
    }
}
