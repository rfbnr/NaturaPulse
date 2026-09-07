//
//  ErrorMapping.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

extension NetworkError {
    func toAppError() -> AppError {
        switch self {
        case .notConnected:
            return .networkUnavailable
        case .statusCode(let code):
            return code == 404 ? .notFound : .server
        case .invalidResponse:
            return .server
        case .decoding:
            return .decoding
        case .invalidURL, .underlying:
            return .unknown
        }
    }
}
