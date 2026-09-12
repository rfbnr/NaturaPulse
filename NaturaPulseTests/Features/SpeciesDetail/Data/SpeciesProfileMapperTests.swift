//
//  SpeciesProfileMapperTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import NaturaPulse

final class SpeciesProfileMapperTests: XCTestCase {
    private func dto(
        _ items: [(String?, String?)]
    ) -> GBIFDescriptionsResponseDTO {
        GBIFDescriptionsResponseDTO(results: items.map {
            GBIFDescriptionDTO(
                type: nil,
                language: "eng",
                description: $0.0,
                source: $0.1
            )
        })
    }

    func testPicksFirstNonEmptyDescription() {
        let profile = SpeciesProfileMapper.map(
            dto([("   ", "s0"), ("", "s1"), ("A spotted dove.", "IOC")])
        )
        XCTAssertEqual(profile.summary, "A spotted dove.")
        XCTAssertEqual(profile.summarySource, "IOC")
    }

    func testNilWhenNoUsableDescription() {
        let profile = SpeciesProfileMapper.map(dto([("  ", "s0"), (nil, "s1")]))
        XCTAssertNil(profile.summary)
        XCTAssertNil(profile.summarySource)
    }

    func testEmptyResults() {
        let profile = SpeciesProfileMapper.map(GBIFDescriptionsResponseDTO(results: []))
        XCTAssertNil(profile.summary)
    }
}
