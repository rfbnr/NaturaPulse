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
        XCTAssertEqual(result.map(\.id), [2, 1]) // most recently saved first
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

    /// The headline reactive behavior (PRD §19): `savedSpecies()` is a live stream, not a
    /// one-shot fetch — a save performed *after* subscribing must push a SECOND emission
    /// reflecting the new state, without resubscribing. Existing tests above only ever
    /// inspect the first emission via `awaitPublisher`; this one collects two emissions
    /// over time with a sink + expectation to prove the re-emission actually happens.
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

        // `save` performs its Realm write synchronously in the method body (before the
        // returned publisher is even subscribed to), so calling it — without going through
        // `awaitPublisher`, which would wait on ALL outstanding expectations including
        // `secondEmission` and make the explicit `wait(for:)` below fail as "already waited
        // on" — is enough to trigger the change notification the subscription above observes.
        _ = repo.save(Species.stub(id: 1))

        wait(for: [secondEmission], timeout: 5)
        cancellable.cancel()

        XCTAssertEqual(emissions.first, [])
        XCTAssertEqual(emissions.last, [1])
    }
}
