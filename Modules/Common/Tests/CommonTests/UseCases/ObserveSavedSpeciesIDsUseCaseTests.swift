//
//  ObserveSavedSpeciesIDsUseCaseTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import Combine
import XCTest
@testable import Common

final class ObserveSavedSpeciesIDsUseCaseTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testMapsSavedSpeciesToIDSet() {
        let repository = FakeFieldGuideRepository()
        repository.savedResult = .success([Species.stub(id: 1), Species.stub(id: 2)])
        let useCase = ObserveSavedSpeciesIDsUseCase(repository: repository)

        var received: Set<Species.ID>?
        let done = expectation(description: "emitted")
        useCase()
            .sink { ids in received = ids; done.fulfill() }
            .store(in: &cancellables)

        wait(for: [done], timeout: 2)
        XCTAssertEqual(received, [1, 2])
    }

    func testErrorBecomesEmptySetAndNeverFails() {
        let repository = FakeFieldGuideRepository()
        repository.savedResult = .failure(.persistence)
        let useCase = ObserveSavedSpeciesIDsUseCase(repository: repository)

        var received: Set<Species.ID>?
        var failed = false
        let done = expectation(description: "completed")
        useCase()
            .sink(
                receiveCompletion: { completion in
                    if case .failure = completion { failed = true }
                    done.fulfill()
                },
                receiveValue: { received = $0 }
            )
            .store(in: &cancellables)

        wait(for: [done], timeout: 2)
        XCTAssertEqual(received, [])
        XCTAssertFalse(failed)
    }
}
