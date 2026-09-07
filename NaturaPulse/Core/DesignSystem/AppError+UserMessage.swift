//
//  AppError+UserMessage.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

/// A human-readable, non-technical message for surfacing an `AppError`
/// in the UI (e.g. `ErrorStateView`).
extension AppError {
    var userMessage: String {
        switch self {
        case .networkUnavailable:
            "You're offline. Check your connection and try again."
        case .server:
            "Something went wrong on our end. Please try again."
        case .decoding:
            "We had trouble reading that response. Please try again."
        case .notFound:
            "We couldn't find what you were looking for."
        case .persistence:
            "We couldn't save your data. Please try again."
        case .locationDenied:
            "Location access is turned off. You can still search for a place."
        case .permissionRestricted:
            "This feature isn't available due to device restrictions."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }
}
