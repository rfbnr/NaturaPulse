//
//  OpenMeteoAirQualityDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct OpenMeteoAirQualityDTO: Decodable, Equatable {
    struct Current: Decodable, Equatable {
        let pm25: Double?

        enum CodingKeys: String, CodingKey {
            case pm25 = "pm2_5"
        }
    }
    let current: Current
}
