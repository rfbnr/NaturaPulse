//
//  RemoteDataSourceTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import XCTest
@testable import NaturaPulse

final class RemoteDataSourceTests: XCTestCase {
    func testGBIFNearbyDecodesResponseAndSendsGeoDistanceQuery() throws {
        let json = #"{"count":1,"results":[{"key":1,"speciesKey":100,"scientificName":"X","media":[{"identifier":"https://i/x.jpg"}]}]}"#
        let client = StubbedAPIClientFactory.make(json: json)
        let source = DefaultGBIFRemoteDataSource(apiClient: client)

        let dto = try awaitPublisher(source.nearby(latitude: -6.2, longitude: 106.8, radiusKm: 10, limit: 20))

        XCTAssertEqual(dto.count, 1)
        XCTAssertEqual(dto.results.first?.speciesKey, 100)
        let url = try XCTUnwrap(StubURLProtocol.lastRequestURL?.absoluteString)
        XCTAssertTrue(url.contains("geoDistance=-6.2,106.8,10km"))
        XCTAssertTrue(url.contains("mediaType=StillImage"))
    }

    func testForecastDecodes() throws {
        let json = #"{"current":{"time":"t","temperature_2m":28.4,"relative_humidity_2m":66,"precipitation":0.0,"weather_code":0}}"#
        let client = StubbedAPIClientFactory.make(json: json)
        let source = DefaultWeatherRemoteDataSource(apiClient: client)
        let dto = try awaitPublisher(source.forecast(latitude: -6.2, longitude: 106.8))
        XCTAssertEqual(dto.current.temperature2m, 28.4)
    }

    func testServerErrorMapsToStatusCodeNetworkError() {
        let client = StubbedAPIClientFactory.make(json: #"{"error":true}"#, statusCode: 500)
        let source = DefaultGeocodingRemoteDataSource(apiClient: client)
        XCTAssertThrowsError(try awaitPublisher(source.search(name: "Jakarta"))) { error in
            guard case NetworkError.statusCode(let code) = error else {
                return XCTFail("Expected statusCode error, got \(error)")
            }
            XCTAssertEqual(code, 500)
        }
    }
}
