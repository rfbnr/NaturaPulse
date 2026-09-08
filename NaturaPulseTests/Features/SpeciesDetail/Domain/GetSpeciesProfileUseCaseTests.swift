//
//  GetSpeciesProfileUseCaseTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

@MainActor
final class GetSpeciesProfileUseCaseTests: XCTestCase {
    func testDelegatesToRepository() throws {
        let repo = FakeSpeciesRepository()
        repo.profileResult = .success(SpeciesProfile(summary: "hi", summarySource: "src"))
        let useCase = GetSpeciesProfileUseCase(repository: repo)
        let profile = try awaitPublisher(useCase(id: 100))
        XCTAssertEqual(profile.summary, "hi")
        XCTAssertEqual(repo.profileID, 100)
    }

    func testPropagatesError() {
        let repo = FakeSpeciesRepository()
        repo.profileResult = .failure(.server)
        let useCase = GetSpeciesProfileUseCase(repository: repo)
        XCTAssertThrowsError(try awaitPublisher(useCase(id: 1))) { error in
            XCTAssertEqual(error as? AppError, .server)
        }
    }
}
