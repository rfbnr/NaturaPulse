//
//  SpeciesDetailPresenterTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

@MainActor
final class SpeciesDetailPresenterTests: XCTestCase {
    private func makePresenter(
        species: Species,
        profile: Result<SpeciesProfile, AppError> = .success(SpeciesProfile(summary: "About.", summarySource: "src")),
        weather: Result<WeatherContext, AppError> = .success(WeatherContext(temperatureCelsius: 28, relativeHumidity: 60, precipitation: 0, weatherCode: 0, pm25: 20, capturedAt: Date()))
    ) -> SpeciesDetailPresenter {
        let speciesRepo = FakeSpeciesRepository()
        speciesRepo.profileResult = profile
        let weatherRepo = FakeWeatherRepository()
        weatherRepo.result = weather
        return SpeciesDetailPresenter(
            species: species,
            getSpeciesProfile: GetSpeciesProfileUseCase(repository: speciesRepo),
            getWeatherContext: GetWeatherContextUseCase(repository: weatherRepo)
        )
    }

    private func settle() {
        let expectation = expectation(description: "settle")
        DispatchQueue.main.async { expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
    }

    func testExposesPassedSpeciesImmediately() {
        let presenter = makePresenter(species: Species.stub(id: 1))
        XCTAssertEqual(presenter.species.id, 1)
    }

    func testOnAppearLoadsProfile() {
        let presenter = makePresenter(species: Species.stub(id: 1, coordinate: Coordinate(latitude: -6.2, longitude: 106.8)))
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.profileState, .loaded(SpeciesProfile(summary: "About.", summarySource: "src")))
        if case .loaded = presenter.weatherState {} else { XCTFail("expected weather loaded") }
    }

    func testWeatherStaysIdleWithoutCoordinate() {
        let presenter = makePresenter(species: Species.stub(id: 1, coordinate: nil))
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.weatherState, .idle)
    }

    func testProfileFailureProducesFailed() {
        let presenter = makePresenter(species: Species.stub(id: 1), profile: .failure(.server))
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.profileState, .failed(.server))
    }

    func testRetryReRunsOnlyFailedProfileNotLoadedWeather() {
        let speciesRepo = FakeSpeciesRepository()
        speciesRepo.profileResult = .failure(.server)
        let weatherRepo = FakeWeatherRepository()
        weatherRepo.result = .success(WeatherContext(temperatureCelsius: 28, relativeHumidity: 60, precipitation: 0, weatherCode: 0, pm25: 20, capturedAt: Date()))
        let presenter = SpeciesDetailPresenter(
            species: Species.stub(id: 1, coordinate: Coordinate(latitude: -6.2, longitude: 106.8)),
            getSpeciesProfile: GetSpeciesProfileUseCase(repository: speciesRepo),
            getWeatherContext: GetWeatherContextUseCase(repository: weatherRepo)
        )
        presenter.onAppear()
        settle()
        XCTAssertEqual(presenter.profileState, .failed(.server))
        if case .loaded = presenter.weatherState {} else { XCTFail("expected weather loaded") }
        XCTAssertEqual(weatherRepo.contextCallCount, 1)

        // Profile now succeeds; retry must re-run profile only, NOT weather.
        speciesRepo.profileResult = .success(SpeciesProfile(summary: "About.", summarySource: "src"))
        presenter.retry()
        settle()
        XCTAssertEqual(presenter.profileState, .loaded(SpeciesProfile(summary: "About.", summarySource: "src")))
        XCTAssertEqual(weatherRepo.contextCallCount, 1) // weather was NOT re-run
    }
}
