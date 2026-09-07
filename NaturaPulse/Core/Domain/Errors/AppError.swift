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
