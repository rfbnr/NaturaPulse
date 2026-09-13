//
//  DomainFoundationTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import NaturaPulse

final class DomainFoundationTests: XCTestCase {

    func testSpeciesEquatableComparesAllFields() {
        let date = Date(timeIntervalSince1970: 0)
        let base = Species.stub(id: 1, scientificName: "Copsychus saularis", lastObservedAt: date)
        let identical = Species.stub(id: 1, scientificName: "Copsychus saularis", lastObservedAt: date)
        let different = Species.stub(id: 2, scientificName: "Acridotheres tristis", lastObservedAt: date)

        XCTAssertEqual(base, identical)
        XCTAssertNotEqual(base, different)
    }

    func testAppErrorIsEquatable() {
        XCTAssertEqual(AppError.persistence, AppError.persistence)
        XCTAssertNotEqual(AppError.persistence, AppError.networkUnavailable)
    }

    func testDistanceKilometersFactory() {
        XCTAssertEqual(Distance.km(10), Distance(kilometers: 10))
    }
}
