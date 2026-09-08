//
//  RepositoryImplTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

private final class FakeGBIFDataSource: GBIFRemoteDataSource {
    var nearbyResult: Result<GBIFOccurrenceResponseDTO, NetworkError> = .success(.init(count: 0, results: []))
    var descriptionsResult: Result<GBIFDescriptionsResponseDTO, NetworkError> = .success(.init(results: []))
    func nearby(latitude: Double, longitude: Double, radiusKm: Int, limit: Int) -> AnyPublisher<GBIFOccurrenceResponseDTO, NetworkError> {
        nearbyResult.publisher.eraseToAnyPublisher()
    }
    func search(query: String, limit: Int) -> AnyPublisher<GBIFOccurrenceResponseDTO, NetworkError> {
        nearbyResult.publisher.eraseToAnyPublisher()
    }
    func speciesDescriptions(speciesKey: Int) -> AnyPublisher<GBIFDescriptionsResponseDTO, NetworkError> {
        descriptionsResult.publisher.eraseToAnyPublisher()
    }
}

private final class FakeWeatherDataSource: WeatherRemoteDataSource {
    var forecastResult: Result<OpenMeteoForecastDTO, NetworkError> = .success(.init(current: .init(time: "t", temperature2m: 28, relativeHumidity2m: 60, precipitation: 0, weatherCode: 0)))
    var airQualityResult: Result<OpenMeteoAirQualityDTO, NetworkError> = .success(.init(current: .init(pm25: 20)))
    func forecast(latitude: Double, longitude: Double) -> AnyPublisher<OpenMeteoForecastDTO, NetworkError> {
        forecastResult.publisher.eraseToAnyPublisher()
    }
    func airQuality(latitude: Double, longitude: Double) -> AnyPublisher<OpenMeteoAirQualityDTO, NetworkError> {
        airQualityResult.publisher.eraseToAnyPublisher()
    }
}

final class RepositoryImplTests: XCTestCase {
    func testNearbyMapsDedupedSpecies() throws {
        let source = FakeGBIFDataSource()
        source.nearbyResult = .success(.init(count: 2, results: [
            GBIFOccurrenceDTO(
                key: 1, speciesKey: 100, taxonKey: 100, scientificName: "X", vernacularName: nil,
                kingdom: nil, phylum: nil, className: nil, order: nil, family: nil, genus: nil,
                eventDate: nil, country: nil, datasetName: nil, media: nil
            ),
            GBIFOccurrenceDTO(
                key: 2, speciesKey: 100, taxonKey: 100, scientificName: "X", vernacularName: nil,
                kingdom: nil, phylum: nil, className: nil, order: nil, family: nil, genus: nil,
                eventDate: nil, country: nil, datasetName: nil, media: nil
            )
        ]))
        let repo = SpeciesRepositoryImpl(dataSource: source)
        let species = try awaitPublisher(repo.getNearbySpecies(at: .jakarta, radius: .km(10)))
        XCTAssertEqual(species.count, 1)
        XCTAssertEqual(species.first?.localObservationCount, 2)
    }

    func testNearbyMapsNetworkErrorToAppError() {
        let source = FakeGBIFDataSource()
        source.nearbyResult = .failure(.statusCode(500))
        let repo = SpeciesRepositoryImpl(dataSource: source)
        XCTAssertThrowsError(try awaitPublisher(repo.getNearbySpecies(at: .jakarta, radius: .km(10)))) { error in
            XCTAssertEqual(error as? AppError, .server)
        }
    }

    func testWeatherDegradesWhenAirQualityFails() throws {
        let source = FakeWeatherDataSource()
        source.airQualityResult = .failure(.notConnected)
        let repo = WeatherRepositoryImpl(dataSource: source, now: { Date(timeIntervalSince1970: 0) })
        let context = try awaitPublisher(repo.context(at: .jakarta))
        XCTAssertEqual(context.temperatureCelsius, 28)
        XCTAssertNil(context.pm25)
    }

    func testWeatherFailsWhenForecastFails() {
        let source = FakeWeatherDataSource()
        source.forecastResult = .failure(.notConnected)
        let repo = WeatherRepositoryImpl(dataSource: source)
        XCTAssertThrowsError(try awaitPublisher(repo.context(at: .jakarta))) { error in
            XCTAssertEqual(error as? AppError, .networkUnavailable)
        }
    }

    func testGetSpeciesProfileMapsDescriptions() throws {
        let source = FakeGBIFDataSource()
        source.descriptionsResult = .success(.init(results: [
            GBIFDescriptionDTO(type: "Habitat", language: "eng", description: "Open woodland.", source: "IOC")
        ]))
        let repo = SpeciesRepositoryImpl(dataSource: source)
        let profile = try awaitPublisher(repo.getSpeciesProfile(id: 6_101_224))
        XCTAssertEqual(profile.summary, "Open woodland.")
        XCTAssertEqual(profile.summarySource, "IOC")
    }

    func testGetSpeciesProfileMapsNetworkErrorToAppError() {
        let source = FakeGBIFDataSource()
        source.descriptionsResult = .failure(.statusCode(500))
        let repo = SpeciesRepositoryImpl(dataSource: source)
        XCTAssertThrowsError(try awaitPublisher(repo.getSpeciesProfile(id: 6_101_224))) { error in
            XCTAssertEqual(error as? AppError, .server)
        }
    }
}
