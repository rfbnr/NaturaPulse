//
//  OpenMeteoForecastDTO.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct OpenMeteoForecastDTO: Decodable, Equatable {
    struct Current: Decodable, Equatable {
        let time: String
        let temperature2m: Double?
        let relativeHumidity2m: Int?
        let precipitation: Double?
        let weatherCode: Int?

        enum CodingKeys: String, CodingKey {
            case time
            case temperature2m = "temperature_2m"
            case relativeHumidity2m = "relative_humidity_2m"
            case precipitation
            case weatherCode = "weather_code"
        }
    }
    let current: Current
}
