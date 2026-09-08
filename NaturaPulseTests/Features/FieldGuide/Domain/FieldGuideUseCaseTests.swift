//
//  FieldGuideUseCaseTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

@MainActor
final class FieldGuideUseCaseTests: XCTestCase {
    func testToggleSavesWhenNotSaved() throws {
        let repo = FakeFieldGuideRepository()
        repo.savedFlag = false
        let useCase = ToggleFavoriteUseCase(repository: repo)
        _ = try awaitPublisher(useCase(Species.stub(id: 1)))
        XCTAssertEqual(repo.savedSpeciesArgID, 1)
        XCTAssertNil(repo.removedID)
    }

    func testToggleRemovesWhenSaved() throws {
        let repo = FakeFieldGuideRepository()
        repo.savedFlag = true
        let useCase = ToggleFavoriteUseCase(repository: repo)
        _ = try awaitPublisher(useCase(Species.stub(id: 7)))
        XCTAssertEqual(repo.removedID, 7)
        XCTAssertNil(repo.savedSpeciesArgID)
    }

    func testRemoveDelegates() throws {
        let repo = FakeFieldGuideRepository()
        let useCase = RemoveSavedSpeciesUseCase(repository: repo)
        _ = try awaitPublisher(useCase(id: 3))
        XCTAssertEqual(repo.removedID, 3)
    }

    func testObserveIsSavedDelegates() throws {
        let repo = FakeFieldGuideRepository()
        repo.savedFlag = true
        let useCase = ObserveIsSavedUseCase(repository: repo)
        XCTAssertTrue(try awaitPublisher(useCase(id: 1)))
    }
}
