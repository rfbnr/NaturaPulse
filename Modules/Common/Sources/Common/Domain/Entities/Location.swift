//
//  Location.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct Location: Equatable {
    public let latitude: Double
    public let longitude: Double
    public let name: String
    public let country: String?
    public let administrativeArea: String?

    public init(
        latitude: Double,
        longitude: Double,
        name: String,
        country: String?,
        administrativeArea: String?
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.country = country
        self.administrativeArea = administrativeArea
    }
}
