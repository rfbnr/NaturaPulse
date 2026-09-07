//
//  APIClient.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import Alamofire

protocol APIClient {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}

final class AlamofireAPIClient: APIClient {
    private let session: Session
    private let decoder: JSONDecoder

    init(session: Session = .default, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        let urlRequest: URLRequest
        do {
            urlRequest = try endpoint.urlRequest()
        } catch {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }

        return session.request(urlRequest)
            .validate()
            .publishDecodable(type: T.self, decoder: decoder)
            .tryMap { response -> T in
                switch response.result {
                case let .success(value):
                    return value
                case let .failure(afError):
                    if let code = response.response?.statusCode, !(200..<300).contains(code) {
                        throw NetworkError.statusCode(code)
                    }
                    if afError.isResponseSerializationError {
                        throw NetworkError.decoding
                    }
                    if afError.isSessionTaskError {
                        throw NetworkError.notConnected
                    }
                    throw NetworkError.underlying(afError.localizedDescription)
                }
            }
            .mapError { error -> NetworkError in
                (error as? NetworkError) ?? .underlying(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}
