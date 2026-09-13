//
//  SearchSpeciesUseCaseTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import Common

@MainActor
final class SearchSpeciesUseCaseTests: XCTestCase {
    func testShortQueryReturnsEmptyWithoutCallingRepository() throws {
        let repo = FakeSpeciesRepository()
        let useCase = SearchSpeciesUseCase(repository: repo)
        let result = try awaitPublisher(useCase(query: " a "))
        XCTAssertTrue(result.isEmpty)
        XCTAssertNil(repo.searchQuery)
    }

    func testTrimsAndDelegates() throws {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .success([Species.stub(id: 1)])
        let useCase = SearchSpeciesUseCase(repository: repo)
        let result = try awaitPublisher(useCase(query: "  Robin  "))
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(repo.searchQuery, "Robin")
    }

    func testPropagatesError() {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .failure(.server)
        let useCase = SearchSpeciesUseCase(repository: repo)
        XCTAssertThrowsError(try awaitPublisher(useCase(query: "Robin"))) { error in
            XCTAssertEqual(error as? AppError, .server)
        }
    }
}
