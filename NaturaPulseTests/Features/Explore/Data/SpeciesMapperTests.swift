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
        key: Int,
        speciesKey: Int?,
        name: String = "Sci name",
        vernacular: String? = nil,
        eventDate: String? = nil,
        imageURL: String? = nil,
        datasetName: String? = nil
    ) -> GBIFOccurrenceDTO {
        let media = imageURL.map {
            [
                GBIFMediaDTO(
                    type: "StillImage",
                    format: nil,
                    identifier: $0,
                    creator: "c",
                    license: "l",
                    references: nil,
                    publisher: nil,
                    rightsHolder: nil
                )
            ]
        }
        
        return GBIFOccurrenceDTO(
            key: key,
            speciesKey: speciesKey,
            taxonKey: speciesKey,
            scientificName: name,
            vernacularName: vernacular,
            kingdom: nil,
            phylum: nil,
            className: nil,
            order: nil,
            family: nil,
            genus: nil,
            eventDate: eventDate,
            country: nil,
            datasetName: datasetName,
            media: media
        )
    }

    private func occWithMedia(
        key: Int,
        speciesKey: Int?,
        media: [GBIFMediaDTO]?
    ) -> GBIFOccurrenceDTO {
        GBIFOccurrenceDTO(
            key: key,
            speciesKey: speciesKey,
            taxonKey: speciesKey,
            scientificName: "Sci name",
            vernacularName: nil,
            kingdom: nil,
            phylum: nil,
            className: nil,
            order: nil,
            family: nil,
            genus: nil,
            eventDate: nil,
            country: nil,
            datasetName: nil,
            media: media
        )
    }

    private func media(
        type: String?,
        identifier: String?
    ) -> GBIFMediaDTO {
        GBIFMediaDTO(
            type: type,
            format: nil,
            identifier: identifier,
            creator: "c",
            license: "l",
            references: nil,
            publisher: nil,
            rightsHolder: nil
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
            key: 9,
            speciesKey: nil,
            taxonKey: 55,
            scientificName: "X",
            vernacularName: nil,
            kingdom: nil,
            phylum: nil,
            className: nil,
            order: nil,
            family: nil,
            genus: nil,
            eventDate: nil,
            country: nil,
            datasetName: nil,
            media: nil
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

    func testPrefersStillImageOverOtherMediaTypes() {
        let occurrence = occWithMedia(key: 1, speciesKey: 100, media: [
            media(type: "Sound", identifier: "https://media/sound.mp3"),
            media(type: "StillImage", identifier: "https://media/still.jpg")
        ])
        let species = SpeciesMapper.map([occurrence])
        XCTAssertEqual(species.first?.image?.url.absoluteString, "https://media/still.jpg")
    }

    func testFallsBackToNilTypedMediaWhenNoStillImagePresent() {
        let occurrence = occWithMedia(key: 1, speciesKey: 100, media: [
            media(type: nil, identifier: "https://media/untyped.jpg")
        ])
        let species = SpeciesMapper.map([occurrence])
        XCTAssertEqual(species.first?.image?.url.absoluteString, "https://media/untyped.jpg")
    }

    func testLastObservedAtIsTheLaterOfTwoEventDates() throws {
        let dtos = [
            occ(key: 1, speciesKey: 100, eventDate: "2026-01-03T08:57"),
            occ(key: 2, speciesKey: 100, eventDate: "2026-06-15T10:00")
        ]
        let species = SpeciesMapper.map(dtos)
        let lastObserved = try XCTUnwrap(species.first?.lastObservedAt)
        let expected = try XCTUnwrap(GBIFDateParser.date(from: "2026-06-15T10:00"))
        XCTAssertEqual(lastObserved, expected)
    }

    func testGroupsUnderBareKeyWhenSpeciesKeyAndTaxonKeyAreNil() {
        let dto = GBIFOccurrenceDTO(
            key: 42,
            speciesKey: nil,
            taxonKey: nil,
            scientificName: "X",
            vernacularName: nil,
            kingdom: nil,
            phylum: nil,
            className: nil,
            order: nil,
            family: nil,
            genus: nil,
            eventDate: nil,
            country: nil,
            datasetName: nil,
            media: nil
        )
        let species = SpeciesMapper.map([dto])
        XCTAssertEqual(species.first?.id, 42)
    }

    func testInvalidIdentifierDoesNotCrashAndYieldsNilImage() {
        let occurrence = occWithMedia(
            key: 1,
            speciesKey: 100,
            media: [
                media(type: "StillImage", identifier: "")
        ])
        let species = SpeciesMapper.map([occurrence])
        XCTAssertNil(species.first?.image)
    }

    func testUpgradesCleartextHTTPImageURLToHTTPS() {
        let occurrence = occWithMedia(
            key: 1,
            speciesKey: 100,
            media: [
                media(type: "StillImage", identifier: "http://biodiversity.bt/img.jpg")
        ])
        let species = SpeciesMapper.map([occurrence])
        XCTAssertEqual(species.first?.image?.url.absoluteString, "https://biodiversity.bt/img.jpg")
    }

    func testLeavesHTTPSImageURLUnchanged() {
        let occurrence = occWithMedia(
            key: 1,
            speciesKey: 100,
            media: [
                media(type: "StillImage", identifier: "https://biodiversity.bt/img.jpg")
        ])
        let species = SpeciesMapper.map([occurrence])
        XCTAssertEqual(species.first?.image?.url.absoluteString, "https://biodiversity.bt/img.jpg")
    }

    func testMapsCoordinateFromRepresentativeOccurrence() {
        let occ = GBIFOccurrenceDTO(
            key: 1,
            speciesKey: 100,
            taxonKey: 100,
            scientificName: "X",
            vernacularName: nil,
            kingdom: nil,
            phylum: nil,
            className: nil,
            order: nil,
            family: nil,
            genus: nil,
            eventDate: nil,
            country: nil,
            datasetName: nil,
            media: nil,
            decimalLatitude: -6.2,
            decimalLongitude: 106.8
        )
        let species = SpeciesMapper.map([occ])
        XCTAssertEqual(
            species.first?.coordinate,
            Coordinate(latitude: -6.2, longitude: 106.8)
        )
    }
}
