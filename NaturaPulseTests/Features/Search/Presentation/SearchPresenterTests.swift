//
//  SearchPresenterTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

@MainActor
final class SearchPresenterTests: XCTestCase {
    private func makePresenter(_ repo: FakeSpeciesRepository) -> SearchPresenter {
        SearchPresenter(
            searchSpecies: SearchSpeciesUseCase(repository: repo),
            debounceInterval: .milliseconds(20),
            scheduler: DispatchQueue.main
        )
    }

    private func waitMillis(_ ms: Int) {
        let expectation = expectation(description: "wait")
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(ms)) { expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
    }

    func testRapidTypingCoalescesToOneSearch() {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .success([Species.stub(id: 1)])
        let presenter = makePresenter(repo)
        presenter.query = "R"
        presenter.query = "Ro"
        presenter.query = "Rob"
        presenter.query = "Robin"
        waitMillis(120)
        XCTAssertEqual(repo.searchCallCount, 1)
        XCTAssertEqual(repo.searchQuery, "Robin")
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 1)]))
    }

    func testEmptyQueryStaysIdleWithoutNetwork() {
        let repo = FakeSpeciesRepository()
        let presenter = makePresenter(repo)
        presenter.query = "R"      // 1 char, below min
        waitMillis(120)
        XCTAssertEqual(repo.searchCallCount, 0)
        XCTAssertEqual(presenter.state, .idle)
    }

    func testNoResultsProducesEmpty() {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .success([])
        let presenter = makePresenter(repo)
        presenter.query = "zzzz"
        waitMillis(120)
        XCTAssertEqual(presenter.state, .empty)
    }

    func testFailureProducesFailedAndSurvivesForNextQuery() {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .failure(.server)
        let presenter = makePresenter(repo)
        presenter.query = "Robin"
        waitMillis(120)
        XCTAssertEqual(presenter.state, .failed(.server))
        // Pipeline must survive an error: a new query still searches.
        repo.searchResult = .success([Species.stub(id: 2)])
        presenter.query = "Myna"
        waitMillis(120)
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 2)]))
    }

    func testRetryReRunsSameQueryAfterFailure() {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .failure(.server)
        let presenter = makePresenter(repo)
        presenter.query = "Robin"
        waitMillis(120)
        XCTAssertEqual(presenter.state, .failed(.server))
        XCTAssertEqual(repo.searchCallCount, 1)

        repo.searchResult = .success([Species.stub(id: 9)])
        presenter.retry()
        waitMillis(120)
        XCTAssertEqual(repo.searchCallCount, 2)
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 9)]))
    }

    func testSelectSpeciesAppendsRoute() {
        let presenter = makePresenter(FakeSpeciesRepository())
        presenter.select(species: Species.stub(id: 7))
        XCTAssertEqual(presenter.path, [AppRoute.speciesDetail(id: 7)])
    }

    func testDuplicateQueryDoesNotRetrigger() {
        let repo = FakeSpeciesRepository()
        repo.searchResult = .success([Species.stub(id: 1)])
        let presenter = makePresenter(repo)
        presenter.query = "Robin"
        waitMillis(60)
        XCTAssertEqual(repo.searchCallCount, 1)
        presenter.query = "Robin"   // identical -> removeDuplicates drops it
        waitMillis(60)
        XCTAssertEqual(repo.searchCallCount, 1)
    }

    func testStaleSearchDoesNotOverwriteNewerResult() {
        let repo = FakeSpeciesRepository()
        let older = PassthroughSubject<[Species], AppError>()
        let newer = PassthroughSubject<[Species], AppError>()
        repo.searchHandler = { query in
            (query == "aaaa" ? older : newer).eraseToAnyPublisher()
        }
        let presenter = makePresenter(repo)
        presenter.query = "aaaa"     // starts older (subscribed after debounce, loading)
        waitMillis(60)
        presenter.query = "bbbb"     // starts newer; switchToLatest cancels older's subscription
        waitMillis(60)
        newer.send([Species.stub(id: 2)])
        newer.send(completion: .finished)
        waitMillis(40)
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 2)]))
        // Stale older result arrives late; its subscription was cancelled, so it must be ignored.
        older.send([Species.stub(id: 1)])
        older.send(completion: .finished)
        waitMillis(40)
        XCTAssertEqual(presenter.state, .loaded([Species.stub(id: 2)]))
    }
}
