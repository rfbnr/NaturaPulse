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

    enum CodingKeys: String, CodingKey {
        case key, speciesKey, taxonKey, scientificName, vernacularName
        case kingdom, phylum
        case className = "class"
        case order, family, genus, eventDate, country, datasetName, media
    }
}
