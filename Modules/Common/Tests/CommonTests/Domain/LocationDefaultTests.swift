//
//  LocationDefaultTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import Common

final class LocationDefaultTests: XCTestCase {
    func testJakartaDefaultHasExpectedCoordinates() {
        let jakarta = Location.jakarta
        XCTAssertEqual(jakarta.name, "Jakarta")
        XCTAssertEqual(jakarta.country, "Indonesia")
        XCTAssertEqual(jakarta.latitude, -6.2, accuracy: 0.0001)
        XCTAssertEqual(jakarta.longitude, 106.8, accuracy: 0.0001)
    }
}
