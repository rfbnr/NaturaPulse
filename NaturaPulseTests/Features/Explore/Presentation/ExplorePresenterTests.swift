//
//  ExplorePresenterTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import XCTest
@testable import NaturaPulse

@MainActor
final class ExplorePresenterTests: XCTestCase {
    private static let defaultWeather = WeatherContext(
        temperatureCelsius: 28,
        relativeHumidity: 60,
        precipitation: 0,
        weatherCode: 0,
        pm25: 20,
        capturedAt: Date()
    )

    private func makePresenter(
        species: Result<[Species], AppError>,
        weather: Result<WeatherContext, AppError> = .success(defaultWeather)
    ) -> ExplorePresenter {
        makePresenterWithRepositories(species: species, weather: weather).presenter
    }

    private func makePresenterWithRepositories(
        species: Result<[Species], AppError>,
        weather: Result<WeatherContext, AppError> = .success(defaultWeather)
    ) -> (presenter: ExplorePresenter, speciesRepo: FakeSpeciesRepository) {
        let speciesRepo = FakeSpeciesRepository()
        speciesRepo.nearbyResult = species
        let weatherRepo = FakeWeatherRepository()
        weatherRepo.result = weather
        let locationRepo = FakeLocationRepository()
        let presenter = ExplorePresenter(
            getNearbySpecies: GetNearbySpeciesUseCase(repository: speciesRepo),
            getWeatherContext: GetWeatherContextUseCase(repository: weatherRepo),
            searchLocation: SearchLocationUseCase(repository: locationRepo)
        )
        return (presenter, speciesRepo)
    }

    /// Waits for a Combine `.receive(on: DispatchQueue.main)` hop to flush
    /// so state updates from a resolved publisher are visible.
    private func waitForMainQueueFlush() {
        let flushed = expectation(description: "main queue flush")
        DispatchQueue.main.async { flushed.fulfill() }
        wait(for: [flushed], timeout: 2)
    }

    func testOnAppearLoadsSpeciesLoaded() {
        let presenter = makePresenter(species: .success([Species.stub(id: 1)]))
        presenter.onAppear()
        let expectation = expectation(description: "loaded")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 1)]))
    }

    func testEmptyResultProducesEmptyState() {
        let presenter = makePresenter(species: .success([]))
        presenter.onAppear()
        let expectation = expectation(description: "empty")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(presenter.speciesState, .empty)
    }

    func testFailureProducesFailedState() {
        let presenter = makePresenter(species: .failure(.server))
        presenter.onAppear()
        let expectation = expectation(description: "failed")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(presenter.speciesState, .failed(.server))
    }

    func testSelectRadiusTriggersReload() {
        let (presenter, speciesRepo) = makePresenterWithRepositories(species: .success([Species.stub(id: 1)]))

        presenter.onAppear()
        waitForMainQueueFlush()
        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 1)]))
        XCTAssertEqual(speciesRepo.nearbyCallCount, 1)

        speciesRepo.nearbyResult = .success([Species.stub(id: 2)])
        presenter.select(radius: .km(25))

        waitForMainQueueFlush()
        XCTAssertEqual(speciesRepo.nearbyCallCount, 2)
        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 2)]))
    }

    func testSelectLocationTriggersReload() {
        let (presenter, speciesRepo) = makePresenterWithRepositories(species: .success([Species.stub(id: 1)]))

        presenter.onAppear()
        waitForMainQueueFlush()
        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 1)]))
        XCTAssertEqual(speciesRepo.nearbyCallCount, 1)

        let bandung = Location(latitude: -6.9, longitude: 107.6, name: "Bandung", country: "Indonesia", administrativeArea: "West Java")
        speciesRepo.nearbyResult = .success([Species.stub(id: 2)])
        presenter.select(location: bandung)

        waitForMainQueueFlush()
        XCTAssertEqual(speciesRepo.nearbyCallCount, 2)
        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 2)]))
        XCTAssertEqual(presenter.location, bandung)
    }

    /// A stale in-flight request (A) must never overwrite a newer request's
    /// (B) result, even if A's value arrives after B has already loaded.
    /// The presenter cancels A's subscription when B starts, so a value
    /// sent on A's subject afterward must simply be dropped.
    func testStaleRequestDoesNotOverwriteNewerResult() {
        let (presenter, speciesRepo) = makePresenterWithRepositories(species: .success([]))
        let subjectA = PassthroughSubject<[Species], AppError>()
        speciesRepo.nearbyPublisher = subjectA.eraseToAnyPublisher()

        presenter.onAppear() // starts request A

        let subjectB = PassthroughSubject<[Species], AppError>()
        speciesRepo.nearbyPublisher = subjectB.eraseToAnyPublisher()
        let bandung = Location(latitude: -6.9, longitude: 107.6, name: "Bandung", country: "Indonesia", administrativeArea: "West Java")
        presenter.select(location: bandung) // starts request B, cancelling A's subscription

        subjectB.send([Species.stub(id: 2)])
        subjectB.send(completion: .finished)
        waitForMainQueueFlush()
        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 2)]))

        // Stale A value arrives after B already resolved — must not land.
        subjectA.send([Species.stub(id: 999)])
        waitForMainQueueFlush()

        XCTAssertEqual(presenter.speciesState, .loaded([Species.stub(id: 2)]))
    }
}
