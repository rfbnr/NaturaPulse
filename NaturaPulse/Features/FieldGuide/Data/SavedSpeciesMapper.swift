//
//  SavedSpeciesMapper.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation
import RealmSwift

enum SavedSpeciesMapper {
    static func object(from species: Species, savedAt: Date) -> SavedSpeciesObject {
        let object = SavedSpeciesObject()
        object.id = species.id
        object.scientificName = species.scientificName
        object.commonName = species.commonName
        object.kingdom = species.kingdom
        object.phylum = species.phylum
        object.className = species.className
        object.order = species.order
        object.family = species.family
        object.genus = species.genus
        object.speciesDescription = species.description
        object.imageURL = species.image?.url.absoluteString
        object.imageCreator = species.image?.creator
        object.imageLicense = species.image?.license
        object.imageSourceURL = species.image?.sourceURL?.absoluteString
        object.localObservationCount = species.localObservationCount
        object.lastObservedAt = species.lastObservedAt
        object.latitude = species.coordinate?.latitude
        object.longitude = species.coordinate?.longitude
        object.sourceDatasetName = species.source?.datasetName
        object.sourcePublisher = species.source?.publisher
        object.sourceReferenceURL = species.source?.referenceURL?.absoluteString
        object.savedAt = savedAt
        return object
    }

    static func domain(from object: SavedSpeciesObject) -> Species {
        Species(
            id: object.id,
            scientificName: object.scientificName,
            commonName: object.commonName,
            kingdom: object.kingdom,
            phylum: object.phylum,
            className: object.className,
            order: object.order,
            family: object.family,
            genus: object.genus,
            description: object.speciesDescription,
            image: image(from: object),
            localObservationCount: object.localObservationCount,
            lastObservedAt: object.lastObservedAt,
            source: source(from: object),
            coordinate: coordinate(from: object)
        )
    }

    private static func image(from object: SavedSpeciesObject) -> SpeciesImage? {
        guard let urlString = object.imageURL, let url = URL(string: urlString) else { return nil }
        return SpeciesImage(
            url: url,
            creator: object.imageCreator,
            license: object.imageLicense,
            sourceURL: object.imageSourceURL.flatMap(URL.init(string:))
        )
    }

    private static func coordinate(from object: SavedSpeciesObject) -> Coordinate? {
        guard let latitude = object.latitude, let longitude = object.longitude else { return nil }
        return Coordinate(latitude: latitude, longitude: longitude)
    }

    private static func source(from object: SavedSpeciesObject) -> ObservationSource? {
        if object.sourceDatasetName == nil, object.sourcePublisher == nil, object.sourceReferenceURL == nil {
            return nil
        }
        return ObservationSource(
            datasetName: object.sourceDatasetName,
            publisher: object.sourcePublisher,
            referenceURL: object.sourceReferenceURL.flatMap(URL.init(string:))
        )
    }
}
