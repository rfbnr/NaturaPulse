//
//  SavedSpeciesObject.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation
import RealmSwift

final class SavedSpeciesObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var scientificName: String
    @Persisted var commonName: String?
    @Persisted var kingdom: String?
    @Persisted var phylum: String?
    @Persisted var className: String?
    @Persisted var order: String?
    @Persisted var family: String?
    @Persisted var genus: String?
    @Persisted var speciesDescription: String?
    @Persisted var imageURL: String?
    @Persisted var imageCreator: String?
    @Persisted var imageLicense: String?
    @Persisted var imageSourceURL: String?
    @Persisted var localObservationCount: Int
    @Persisted var lastObservedAt: Date?
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var sourceDatasetName: String?
    @Persisted var sourcePublisher: String?
    @Persisted var sourceReferenceURL: String?
    @Persisted var savedAt: Date
}
