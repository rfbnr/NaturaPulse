//
//  DTODecodingTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import Common

final class DTODecodingTests: XCTestCase {
    private func decode<T: Decodable>(_ type: T.Type, _ json: String) throws -> T {
        let data = try XCTUnwrap(json.data(using: .utf8))
        return try JSONDecoder().decode(T.self, from: data)
    }

    func testDecodesGBIFOccurrenceResponseWithClassKeyAndOptionalMedia() throws {
        let json = """
        {"count":9851,"results":[
          {"key":123,"speciesKey":6101224,"taxonKey":6101224,"scientificName":"Spilopelia chinensis",
           "vernacularName":null,"kingdom":"Animalia","class":"Aves","family":"Columbidae","genus":"Spilopelia",
           "eventDate":"2026-01-03T08:57","country":"Indonesia",
           "media":[{"type":"StillImage","identifier":"https://img/x.jpg","license":"CC BY-NC 4.0","creator":"jj"}]}
        ]}
        """
        let dto = try decode(GBIFOccurrenceResponseDTO.self, json)
        XCTAssertEqual(dto.count, 9851)
        XCTAssertEqual(dto.results.count, 1)
        let first = try XCTUnwrap(dto.results.first)
        XCTAssertEqual(first.key, 123)
        XCTAssertEqual(first.speciesKey, 6101224)
        XCTAssertEqual(first.className, "Aves")
        XCTAssertNil(first.vernacularName)
        XCTAssertEqual(first.media?.first?.identifier, "https://img/x.jpg")
    }

    func testDecodesForecastCurrentSnakeCase() throws {
        let json = """
        {"current":{"time":"2026-09-07T16:30","temperature_2m":28.4,"relative_humidity_2m":66,"precipitation":0.0,"weather_code":0}}
        """
        let dto = try decode(OpenMeteoForecastDTO.self, json)
        XCTAssertEqual(dto.current.temperature2m, 28.4)
        XCTAssertEqual(dto.current.relativeHumidity2m, 66)
        XCTAssertEqual(dto.current.weatherCode, 0)
    }

    func testDecodesAirQualityPM25() throws {
        let dto = try decode(OpenMeteoAirQualityDTO.self, #"{"current":{"pm2_5":23.5}}"#)
        XCTAssertEqual(dto.current.pm25, 23.5)
    }

    func testDecodesGeocodingAndToleratesMissingResults() throws {
        let json = #"""
        {"results":[{"name":"Jakarta","latitude":-6.2,"longitude":106.8,"admin1":"Jakarta","country":"Indonesia","country_code":"ID"}]}
        """#
        let withResults = try decode(GeocodingResponseDTO.self, json)
        XCTAssertEqual(withResults.results?.first?.name, "Jakarta")
        XCTAssertEqual(withResults.results?.first?.admin1, "Jakarta")
        let empty = try decode(GeocodingResponseDTO.self, #"{"generationtime_ms":0.1}"#)
        XCTAssertNil(empty.results)
    }
}
