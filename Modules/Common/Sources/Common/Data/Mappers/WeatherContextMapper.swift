//
//  WeatherContextMapper.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum WeatherContextMapper {
    static func map(
        forecast: OpenMeteoForecastDTO,
        airQuality: OpenMeteoAirQualityDTO?,
        capturedAt: Date
    ) -> WeatherContext {
        WeatherContext(
            temperatureCelsius: forecast.current.temperature2m,
            relativeHumidity: forecast.current.relativeHumidity2m.map(Double.init),
            precipitation: forecast.current.precipitation,
            weatherCode: forecast.current.weatherCode,
            pm25: airQuality?.current.pm25,
            capturedAt: capturedAt
        )
    }
}
