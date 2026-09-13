//
//  GenericVerticalTests.swift
//  CommonTests
//
//  Created by Ridwan Febnur AR on 13/09/26.
//

import Combine
import XCTest
@testable import Common
import CommonTestSupport

final class GenericVerticalTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    func testInteractorExecutesThroughGenericRepository() {
        let fake = FakeSpeciesRepository()
        fake.nearbyResult = .success([Species.stub(id: 1), Species.stub(id: 2)])
        let interactor = Interactor<NearbySpeciesRequest, [Species], NearbySpeciesRepository>(
            repository: NearbySpeciesRepository(source: fake)
        )

        var received: [Species]?
        let done = expectation(description: "executed")
        interactor
            .execute(NearbySpeciesRequest(location: .jakarta, radius: .km(10)))
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                received = value
                done.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [done], timeout: 2)
        XCTAssertEqual(received?.map(\.id), [1, 2])
        XCTAssertEqual(fake.nearbyCallCount, 1)
    }

    func testUseCaseConformsToGenericUseCaseProtocol() {
        let fake = FakeSpeciesRepository()
        fake.nearbyResult = .success([Species.stub(id: 7)])
        let useCase: any UseCase = GetNearbySpeciesUseCase(repository: fake)

        var received: [Species]?
        let done = expectation(description: "executed")
        (useCase as? GetNearbySpeciesUseCase)?
            .execute(NearbySpeciesRequest(location: .jakarta, radius: .km(5)))
            .sink(receiveCompletion: { _ in }, receiveValue: { value in
                received = value
                done.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [done], timeout: 2)
        XCTAssertEqual(received?.map(\.id), [7])
    }
}
