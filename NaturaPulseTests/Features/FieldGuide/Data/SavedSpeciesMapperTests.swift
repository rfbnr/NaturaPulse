//
//  SavedSpeciesMapperTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
@testable import NaturaPulse

final class SavedSpeciesMapperTests: XCTestCase {
    func testRoundTripPreservesFields() throws {
        let image = SpeciesImage(
            url: try XCTUnwrap(URL(string: "https://img/x.jpg")),
            creator: "jj",
            license: "CC BY-NC 4.0",
            sourceURL: URL(string: "https://ref/1")
        )
        let species = Species(
            id: 100,
            scientificName: "Spilopelia chinensis",
            commonName: "Spotted Dove",
            kingdom: "Animalia",
            phylum: "Chordata",
            className: "Aves",
            order: "Columbiformes",
            family: "Columbidae",
            genus: "Spilopelia",
            description: "About.",
            image: image,
            localObservationCount: 5,
            lastObservedAt: Date(timeIntervalSince1970: 1000),
            source: ObservationSource(
                datasetName: "ds",
                publisher: "pub",
                referenceURL: URL(string: "https://ref/2")
            ),
            coordinate: Coordinate(latitude: -6.2, longitude: 106.8)
        )

        let object = SavedSpeciesMapper.object(
            from: species,
            savedAt: Date(timeIntervalSince1970: 2000)
        )
        let restored = SavedSpeciesMapper.domain(from: object)

        XCTAssertEqual(restored, species)
        XCTAssertEqual(object.savedAt, Date(timeIntervalSince1970: 2000))
    }

    func testRoundTripWithNilOptionals() {
        let species = Species.stub(id: 1, commonName: nil)
        let object = SavedSpeciesMapper.object(from: species, savedAt: Date())
        let restored = SavedSpeciesMapper.domain(from: object)
        XCTAssertEqual(restored.id, 1)
        XCTAssertNil(restored.image)
        XCTAssertNil(restored.coordinate)
    }
}
