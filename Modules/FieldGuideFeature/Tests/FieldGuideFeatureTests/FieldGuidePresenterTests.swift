//
//  FieldGuidePresenterTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import FieldGuideFeature
import Common
import CommonTestSupport

@MainActor
final class FieldGuidePresenterTests: XCTestCase {
    private func makePresenter(_ repo: FakeFieldGuideRepository) -> FieldGuidePresenter {
        FieldGuidePresenter(
            getSavedSpecies: GetSavedSpeciesUseCase(repository: repo),
            removeSavedSpecies: RemoveSavedSpeciesUseCase(repository: repo)
        )
    }

    private func settle() {
        let expectation = expectation(description: "settle")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
    }

    func testOnAppearLoadsSaved() {
        let repo = FakeFieldGuideRepository()
        repo.savedResult = .success([Species.stub(id: 1)])
        let presenter = makePresenter(repo)
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 1)]))
    }

    func testEmptyProducesEmpty() {
        let repo = FakeFieldGuideRepository()
        repo.savedResult = .success([])
        let presenter = makePresenter(repo)
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.state, .empty)
    }

    func testRemoveCallsUseCase() {
        let repo = FakeFieldGuideRepository()
        repo.savedResult = .success([Species.stub(id: 1)])
        let presenter = makePresenter(repo)
        presenter.onAppear()
        settle()
        presenter.remove(id: 1)
        settle()
        XCTAssertEqual(repo.removedID, 1)
    }

    func testSelectAppendsRoute() {
        let presenter = makePresenter(FakeFieldGuideRepository())
        presenter.select(species: Species.stub(id: 5))
        XCTAssertEqual(presenter.path, [AppRoute.speciesDetail(Species.stub(id: 5))])
    }

    func testRetryReloadsFromFailedState() {
        let repo = FakeFieldGuideRepository()
        repo.savedResult = .failure(.persistence)
        let presenter = makePresenter(repo)
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.state, .failed(.persistence))
        repo.savedResult = .success([Species.stub(id: 1)])
        presenter.retry()
        settle()
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 1)]))
    }
}
