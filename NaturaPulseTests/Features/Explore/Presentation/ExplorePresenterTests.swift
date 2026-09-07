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
    private func makePresenter(
        species: Result<[Species], AppError>,
        weather: Result<WeatherContext, AppError> = .success(WeatherContext(temperatureCelsius: 28, relativeHumidity: 60, precipitation: 0, weatherCode: 0, pm25: 20, capturedAt: Date()))
    ) -> ExplorePresenter {
        let speciesRepo = FakeSpeciesRepository()
        speciesRepo.nearbyResult = species
        let weatherRepo = FakeWeatherRepository()
        weatherRepo.result = weather
        let locationRepo = FakeLocationRepository()
        return ExplorePresenter(
            getNearbySpecies: GetNearbySpeciesUseCase(repository: speciesRepo),
            getWeatherContext: GetWeatherContextUseCase(repository: weatherRepo),
            searchLocation: SearchLocationUseCase(repository: locationRepo)
        )
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
}
