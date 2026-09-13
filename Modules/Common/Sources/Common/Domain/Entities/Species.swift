//
//  Species.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct Species: Identifiable, Equatable, Hashable {
    public let id: Int
    public let scientificName: String
    public let commonName: String?
    public let kingdom: String?
    public let phylum: String?
    public let className: String?
    public let order: String?
    public let family: String?
    public let genus: String?
    public let description: String?
    public let image: SpeciesImage?
    public let localObservationCount: Int
    public let lastObservedAt: Date?
    public let source: ObservationSource?
    public let coordinate: Coordinate?

    public init(
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
