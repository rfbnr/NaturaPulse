//
//  DescriptionsDataSourceTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import NaturaPulse

final class DescriptionsDataSourceTests: XCTestCase {
    func testDescriptionsDecodeAndHitTheRightPath() throws {
        let json = #"{"results":[{"type":"Habitat","language":"eng","description":"Open woodland.","source":"IOC"}]}"#
        let client = StubbedAPIClientFactory.make(json: json)
        let source = DefaultGBIFRemoteDataSource(apiClient: client)
        let dto = try awaitPublisher(source.speciesDescriptions(speciesKey: 6101224))
        XCTAssertEqual(dto.results.first?.description, "Open woodland.")
        let url = try XCTUnwrap(StubURLProtocol.lastRequestURL?.absoluteString)
        XCTAssertTrue(url.contains("/v1/species/6101224/descriptions"))
    }
}
