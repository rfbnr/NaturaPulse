//
//  SpeciesHashableTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import NaturaPulse

final class SpeciesHashableTests: XCTestCase {
    func testEqualSpeciesHaveEqualHashes() {
        let a = Species.stub(id: 1)
        let b = Species.stub(id: 1)
        XCTAssertEqual(a, b)
        XCTAssertEqual(a.hashValue, b.hashValue)
    }

    func testSpeciesUsableInSet() {
        let set: Set<Species> = [Species.stub(id: 1), Species.stub(id: 2), Species.stub(id: 1)]
        XCTAssertEqual(set.count, 2)
    }

    func testCoordinateStored() {
        let species = Species.stub(
            id: 1,
            coordinate: Coordinate(latitude: -6.2, longitude: 106.8)
        )
        XCTAssertEqual(
            species.coordinate,
            Coordinate(latitude: -6.2, longitude: 106.8)
        )
    }

    func testSpeciesProfileEquatable() {
        XCTAssertEqual(
            SpeciesProfile(summary: "s", summarySource: "src"),
            SpeciesProfile(summary: "s", summarySource: "src")
        )
    }
}
