//
//  WeatherContext.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct WeatherContext: Equatable {
    let temperatureCelsius: Double?
    let relativeHumidity: Double?
    let precipitation: Double?
    let weatherCode: Int?
    let pm25: Double?
    let capturedAt: Date
}
