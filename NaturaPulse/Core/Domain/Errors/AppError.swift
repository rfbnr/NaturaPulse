//
//  AppError.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

enum AppError: Error, Equatable {
    case networkUnavailable
    case server
    case decoding
    case notFound
    case persistence
    case locationDenied
    case permissionRestricted
    case unknown
}
