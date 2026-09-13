//
//  GeocodingRemoteDataSource.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

protocol GeocodingRemoteDataSource {
    func search(name: String) -> AnyPublisher<GeocodingResponseDTO, NetworkError>
}

final class DefaultGeocodingRemoteDataSource: GeocodingRemoteDataSource {
    private let apiClient: APIClient
    private let baseURL = URL(string: "https://geocoding-api.open-meteo.com")

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func search(name: String) -> AnyPublisher<GeocodingResponseDTO, NetworkError> {
        let endpoint = Endpoint(
            baseURL: baseURL ?? URL(fileURLWithPath: "/"),
            path: "/v1/search",
            queryItems: [
                URLQueryItem(name: "name", value: name),
                URLQueryItem(name: "count", value: "5"),
                URLQueryItem(name: "language", value: "en"),
                URLQueryItem(name: "format", value: "json")
            ]
        )
        
        return apiClient.request(endpoint)
    }
}
