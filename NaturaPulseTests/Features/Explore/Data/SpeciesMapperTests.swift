//
//  SpeciesMapperTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import NaturaPulse

final class SpeciesMapperTests: XCTestCase {
    private func occ(
        key: Int, speciesKey: Int?, name: String = "Sci name", vernacular: String? = nil,
        eventDate: String? = nil, imageURL: String? = nil, datasetName: String? = nil
    ) -> GBIFOccurrenceDTO {
        let media = imageURL.map {
            [GBIFMediaDTO(
                type: "StillImage", format: nil, identifier: $0, creator: "c", license: "l",
                references: nil, publisher: nil, rightsHolder: nil
            )]
        }
        return GBIFOccurrenceDTO(
            key: key, speciesKey: speciesKey, taxonKey: speciesKey, scientificName: name, vernacularName: vernacular,
            kingdom: nil, phylum: nil, className: nil, order: nil, family: nil, genus: nil,
            eventDate: eventDate, country: nil, datasetName: datasetName, media: media
        )
    }

    func testDedupesBySpeciesKeyAndCountsOccurrences() {
        let dtos = [
            occ(key: 1, speciesKey: 100),
            occ(key: 2, speciesKey: 100),
            occ(key: 3, speciesKey: 200)
        ]
        let species = SpeciesMapper.map(dtos)
        XCTAssertEqual(species.count, 2)
        XCTAssertEqual(species.first?.id, 100)
        XCTAssertEqual(species.first?.localObservationCount, 2)
        XCTAssertEqual(species.last?.id, 200)
        XCTAssertEqual(species.last?.localObservationCount, 1)
    }

    func testPrefersOccurrenceWithUsableImage() {
        let dtos = [
            occ(key: 1, speciesKey: 100, imageURL: nil),
            occ(key: 2, speciesKey: 100, imageURL: "https://img/y.jpg")
        ]
        let species = SpeciesMapper.map(dtos)
        XCTAssertEqual(species.count, 1)
        XCTAssertEqual(species.first?.image?.url.absoluteString, "https://img/y.jpg")
    }

    func testFallsBackToSpeciesKeyThenTaxonThenKeyForGrouping() {
        let noSpeciesKey = GBIFOccurrenceDTO(
            key: 9, speciesKey: nil, taxonKey: 55, scientificName: "X", vernacularName: nil,
            kingdom: nil, phylum: nil, className: nil, order: nil, family: nil, genus: nil,
            eventDate: nil, country: nil, datasetName: nil, media: nil
        )
        let species = SpeciesMapper.map([noSpeciesKey])
        XCTAssertEqual(species.first?.id, 55)
    }

    func testParsesTimezonelessEventDateAsLastObserved() {
        let dtos = [occ(key: 1, speciesKey: 100, eventDate: "2026-01-03T08:57")]
        let species = SpeciesMapper.map(dtos)
        XCTAssertNotNil(species.first?.lastObservedAt)
    }

    func testUsesVernacularWhenPresentAndNilOtherwise() {
        let named = SpeciesMapper.map([occ(key: 1, speciesKey: 100, vernacular: "Robin")])
        XCTAssertEqual(named.first?.commonName, "Robin")
        let unnamed = SpeciesMapper.map([occ(key: 2, speciesKey: 200, vernacular: nil)])
        XCTAssertNil(unnamed.first?.commonName)
    }
}
