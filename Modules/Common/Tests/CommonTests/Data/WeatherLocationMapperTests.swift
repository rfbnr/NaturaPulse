//
//  WeatherLocationMapperTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import Common

final class WeatherLocationMapperTests: XCTestCase {
    func testMapsForecastWithAirQuality() {
        let forecast = OpenMeteoForecastDTO(
            current: .init(
                time: "t",
                temperature2m: 28.4,
                relativeHumidity2m: 66,
                precipitation: 0,
                weatherCode: 0
            )
        )
        let air = OpenMeteoAirQualityDTO(current: .init(pm25: 23.5))
        let when = Date(timeIntervalSince1970: 1000)
        let context = WeatherContextMapper.map(
            forecast: forecast,
            airQuality: air,
            capturedAt: when
        )
        XCTAssertEqual(context.temperatureCelsius, 28.4)
        XCTAssertEqual(context.relativeHumidity, 66)
        XCTAssertEqual(context.pm25, 23.5)
        XCTAssertEqual(context.capturedAt, when)
    }

    func testMapsForecastWithNilAirQuality() {
        let forecast = OpenMeteoForecastDTO(
            current: .init(
                time: "t",
                temperature2m: 30,
                relativeHumidity2m: nil,
                precipitation: nil,
                weatherCode: nil
            )
        )
        let context = WeatherContextMapper.map(
            forecast: forecast,
            airQuality: nil,
            capturedAt: Date()
        )
        XCTAssertEqual(context.temperatureCelsius, 30)
        XCTAssertNil(context.pm25)
        XCTAssertNil(context.relativeHumidity)
    }

    func testMapsGeocodingToLocationUsingAdmin1() {
        let dto = GeocodingResultDTO(
            id: 1,
            name: "Jakarta",
            latitude: -6.2,
            longitude: 106.8,
            country: "Indonesia",
            admin1: "Jakarta",
            admin2: nil,
            countryCode: "ID"
        )
        let locations = LocationMapper.map([dto])
        XCTAssertEqual(locations.first?.name, "Jakarta")
        XCTAssertEqual(locations.first?.administrativeArea, "Jakarta")
        XCTAssertEqual(locations.first?.country, "Indonesia")
    }
}
