//
//  WeatherContext.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct WeatherContext: Equatable {
    public let temperatureCelsius: Double?
    public let relativeHumidity: Double?
    public let precipitation: Double?
    public let weatherCode: Int?
    public let pm25: Double?
    public let capturedAt: Date

    public init(
        temperatureCelsius: Double?,
        relativeHumidity: Double?,
        precipitation: Double?,
        weatherCode: Int?,
        pm25: Double?,
        capturedAt: Date
    ) {
        self.temperatureCelsius = temperatureCelsius
        self.relativeHumidity = relativeHumidity
        self.precipitation = precipitation
        self.weatherCode = weatherCode
        self.pm25 = pm25
        self.capturedAt = capturedAt
    }
}
