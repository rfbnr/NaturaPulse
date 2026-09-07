//
//  SpeciesStub.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation
@testable import NaturaPulse

extension Species {
    static func stub(
        id: Int = 1,
        scientificName: String = "Copsychus saularis",
        commonName: String? = "Oriental Magpie Robin",
        lastObservedAt: Date? = nil
    ) -> Species {
        Species(
            id: id,
            scientificName: scientificName,
            commonName: commonName,
            kingdom: "Animalia",
            phylum: "Chordata",
            className: "Aves",
            order: "Passeriformes",
            family: "Muscicapidae",
            genus: "Copsychus",
            description: nil,
            image: nil,
            localObservationCount: 3,
            lastObservedAt: lastObservedAt,
            source: nil
        )
    }
}
