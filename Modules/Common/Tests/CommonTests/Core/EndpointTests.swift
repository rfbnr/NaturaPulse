//
//  EndpointTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import Common

final class EndpointTests: XCTestCase {

    func testBuildsURLRequestWithQueryItems() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://api.gbif.org"))
        let endpoint = Endpoint(
            baseURL: baseURL,
            path: "/v1/occurrence/search",
            method: .get,
            queryItems: [URLQueryItem(name: "limit", value: "20")]
        )

        let request = try endpoint.urlRequest()

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(
            request.url?.absoluteString,
            "https://api.gbif.org/v1/occurrence/search?limit=20"
        )
    }

    func testDefaultsToGetWithNoQueryItems() throws {
        let baseURL = try XCTUnwrap(URL(string: "https://api.gbif.org"))
        let endpoint = Endpoint(baseURL: baseURL, path: "/v1/ping")

        let request = try endpoint.urlRequest()

        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.absoluteString, "https://api.gbif.org/v1/ping")
    }
}
