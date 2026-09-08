//
//  Species.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct Species: Identifiable, Equatable, Hashable {
    let id: Int
    let scientificName: String
    let commonName: String?
    let kingdom: String?
    let phylum: String?
    let className: String?
    let order: String?
    let family: String?
    let genus: String?
    let description: String?
    let image: SpeciesImage?
    let localObservationCount: Int
    let lastObservedAt: Date?
    let source: ObservationSource?
    let coordinate: Coordinate?

    init(
        id: Int,
        scientificName: String,
        commonName: String?,
        kingdom: String?,
        phylum: String?,
        className: String?,
        order: String?,
        family: String?,
        genus: String?,
        description: String?,
        image: SpeciesImage?,
        localObservationCount: Int,
        lastObservedAt: Date?,
        source: ObservationSource?,
        coordinate: Coordinate? = nil
    ) {
        self.id = id
        self.scientificName = scientificName
        self.commonName = commonName
        self.kingdom = kingdom
        self.phylum = phylum
        self.className = className
        self.order = order
        self.family = family
        self.genus = genus
        self.description = description
        self.image = image
        self.localObservationCount = localObservationCount
        self.lastObservedAt = lastObservedAt
        self.source = source
        self.coordinate = coordinate
    }
}
