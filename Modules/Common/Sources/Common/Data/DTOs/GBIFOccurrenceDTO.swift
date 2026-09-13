//
//  GBIFOccurrenceDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct GBIFOccurrenceDTO: Decodable, Equatable {
    let key: Int
    let speciesKey: Int?
    let taxonKey: Int?
    let scientificName: String?
    let vernacularName: String?
    let kingdom: String?
    let phylum: String?
    let className: String?
    let order: String?
    let family: String?
    let genus: String?
    let eventDate: String?
    let country: String?
    let datasetName: String?
    let media: [GBIFMediaDTO]?
    let decimalLatitude: Double?
    let decimalLongitude: Double?

    enum CodingKeys: String, CodingKey {
        case key, speciesKey, taxonKey, scientificName, vernacularName
        case kingdom, phylum
        case className = "class"
        case order, family, genus, eventDate, country, datasetName, media
        case decimalLatitude, decimalLongitude
    }

    init(
        key: Int,
        speciesKey: Int?,
        taxonKey: Int?,
        scientificName: String?,
        vernacularName: String?,
        kingdom: String?,
        phylum: String?,
        className: String?,
        order: String?,
        family: String?,
        genus: String?,
        eventDate: String?,
        country: String?,
        datasetName: String?,
        media: [GBIFMediaDTO]?,
        decimalLatitude: Double? = nil,
        decimalLongitude: Double? = nil
    ) {
        self.key = key
        self.speciesKey = speciesKey
        self.taxonKey = taxonKey
        self.scientificName = scientificName
        self.vernacularName = vernacularName
        self.kingdom = kingdom
        self.phylum = phylum
        self.className = className
        self.order = order
        self.family = family
        self.genus = genus
        self.eventDate = eventDate
        self.country = country
        self.datasetName = datasetName
        self.media = media
        self.decimalLatitude = decimalLatitude
        self.decimalLongitude = decimalLongitude
    }
}
