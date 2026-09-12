//
//  LocationMapper.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum LocationMapper {
    static func map(
        _ dtos: [GeocodingResultDTO]
    ) -> [Location] {
        dtos.map { dto in
            Location(
                latitude: dto.latitude,
                longitude: dto.longitude,
                name: dto.name,
                country: dto.country,
                administrativeArea: dto.admin1
            )
        }
    }
}
