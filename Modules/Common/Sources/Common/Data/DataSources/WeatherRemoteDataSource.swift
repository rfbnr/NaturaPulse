//
//  WeatherRemoteDataSource.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

protocol WeatherRemoteDataSource {
    func forecast(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<OpenMeteoForecastDTO, NetworkError>
    
    func airQuality(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<OpenMeteoAirQualityDTO, NetworkError>
}

final class DefaultWeatherRemoteDataSource: WeatherRemoteDataSource {
    private let apiClient: APIClient
    private let forecastBase = URL(string: "https://api.open-meteo.com")
    private let airQualityBase = URL(string: "https://air-quality-api.open-meteo.com")

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func forecast(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<OpenMeteoForecastDTO, NetworkError> {
        let endpoint = Endpoint(
            baseURL: forecastBase ?? URL(fileURLWithPath: "/"),
            path: "/v1/forecast",
            queryItems: [
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "current", value: "temperature_2m,relative_humidity_2m,precipitation,weather_code")
            ]
        )
        
        return apiClient.request(endpoint)
    }

    func airQuality(
        latitude: Double,
        longitude: Double
    ) -> AnyPublisher<OpenMeteoAirQualityDTO, NetworkError> {
        let endpoint = Endpoint(
            baseURL: airQualityBase ?? URL(fileURLWithPath: "/"),
            path: "/v1/air-quality",
            queryItems: [
                URLQueryItem(name: "latitude", value: "\(latitude)"),
                URLQueryItem(name: "longitude", value: "\(longitude)"),
                URLQueryItem(name: "current", value: "pm2_5")
            ]
        )
        
        return apiClient.request(endpoint)
    }
}
