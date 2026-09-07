//
//  GeocodingResponseDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct GeocodingResponseDTO: Decodable, Equatable {
    let results: [GeocodingResultDTO]?
}

struct GeocodingResultDTO: Decodable, Equatable {
    let id: Int?
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
    let admin2: String?
    let countryCode: String?

    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, country, admin1, admin2
        case countryCode = "country_code"
    }
}
