//
//  FieldGuideRepositoryImplTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

@MainActor
final class FieldGuideRepositoryImplTests: XCTestCase {
    private func makeRepo() throws -> FieldGuideRepositoryImpl {
        FieldGuideRepositoryImpl(realmProvider: try InMemoryRealmProvider())
    }

    func testSaveThenSavedSpeciesEmitsIt() throws {
        let repo = try makeRepo()
        _ = try awaitPublisher(repo.save(Species.stub(id: 1)))
        let result = try awaitPublisher(repo.savedSpecies())
        XCTAssertEqual(result.map(\.id), [1])
    }

    func testSaveIsUpsert() throws {
        let repo = try makeRepo()
        _ = try awaitPublisher(repo.save(Species.stub(id: 1, scientificName: "First")))
        _ = try awaitPublisher(repo.save(Species.stub(id: 1, scientificName: "Second")))
        let result = try awaitPublisher(repo.savedSpecies())
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.scientificName, "Second")
    }

    func testSavedSpeciesSortedBySavedAtDescending() throws {
        let repo = try makeRepo()
        _ = try awaitPublisher(repo.save(Species.stub(id: 1)))
        _ = try awaitPublisher(repo.save(Species.stub(id: 2)))
        let result = try awaitPublisher(repo.savedSpecies())
        XCTAssertEqual(result.map(\.id), [2, 1])
    }

    func testRemove() throws {
        let repo = try makeRepo()
        _ = try awaitPublisher(repo.save(Species.stub(id: 1)))
        _ = try awaitPublisher(repo.remove(id: 1))
        let result = try awaitPublisher(repo.savedSpecies())
        XCTAssertTrue(result.isEmpty)
    }

    func testIsSavedReflectsPresence() throws {
        let repo = try makeRepo()
        XCTAssertEqual(try awaitPublisher(repo.isSaved(1)), false)
        _ = try awaitPublisher(repo.save(Species.stub(id: 1)))
        XCTAssertEqual(try awaitPublisher(repo.isSaved(1)), true)
    }

    func testSavedSpeciesReEmitsAfterSave() throws {
        let repo = try makeRepo()

        var emissions: [[Int]] = []
        let secondEmission = expectation(description: "savedSpecies emits again after save")
        secondEmission.expectedFulfillmentCount = 2
        let cancellable = repo.savedSpecies()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { species in
                    emissions.append(species.map(\.id))
                    secondEmission.fulfill()
                }
            )

        _ = repo.save(Species.stub(id: 1))

        wait(for: [secondEmission], timeout: 5)
        cancellable.cancel()

        XCTAssertEqual(emissions.first, [])
        XCTAssertEqual(emissions.last, [1])
    }
}
