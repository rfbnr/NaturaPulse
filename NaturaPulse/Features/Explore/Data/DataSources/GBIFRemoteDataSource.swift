//
//  GBIFRemoteDataSource.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

protocol GBIFRemoteDataSource {
    func nearby(latitude: Double, longitude: Double, radiusKm: Int, limit: Int) -> AnyPublisher<GBIFOccurrenceResponseDTO, NetworkError>
    func search(query: String, limit: Int) -> AnyPublisher<GBIFOccurrenceResponseDTO, NetworkError>
    func speciesDescriptions(speciesKey: Int) -> AnyPublisher<GBIFDescriptionsResponseDTO, NetworkError>
}

final class DefaultGBIFRemoteDataSource: GBIFRemoteDataSource {
    private let apiClient: APIClient
    private let baseURL = URL(string: "https://api.gbif.org")

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    private func base() -> URL {
        baseURL ?? URL(fileURLWithPath: "/")
    }

    func nearby(latitude: Double, longitude: Double, radiusKm: Int, limit: Int) -> AnyPublisher<GBIFOccurrenceResponseDTO, NetworkError> {
        let endpoint = Endpoint(
            baseURL: base(),
            path: "/v1/occurrence/search",
            queryItems: [
                URLQueryItem(name: "geoDistance", value: "\(latitude),\(longitude),\(radiusKm)km"),
                URLQueryItem(name: "mediaType", value: "StillImage"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        )
        return apiClient.request(endpoint)
    }

    func search(query: String, limit: Int) -> AnyPublisher<GBIFOccurrenceResponseDTO, NetworkError> {
        let endpoint = Endpoint(
            baseURL: base(),
            path: "/v1/occurrence/search",
            queryItems: [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "mediaType", value: "StillImage"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        )
        return apiClient.request(endpoint)
    }

    func speciesDescriptions(speciesKey: Int) -> AnyPublisher<GBIFDescriptionsResponseDTO, NetworkError> {
        let endpoint = Endpoint(
            baseURL: base(),
            path: "/v1/species/\(speciesKey)/descriptions",
            queryItems: [URLQueryItem(name: "limit", value: "5")]
        )
        return apiClient.request(endpoint)
    }
}
