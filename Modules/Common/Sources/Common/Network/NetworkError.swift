//
//  NetworkError.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum NetworkError: Error, Equatable {
    case invalidURL
    case notConnected
    case invalidResponse
    case statusCode(Int)
    case decoding
    case underlying(String)
}
