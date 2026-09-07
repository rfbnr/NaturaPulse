//
//  Colors.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// Semantic color tokens used across the app. Colors adapt to light/dark
/// mode via system colors except `accent`, which is a fixed brand green.
enum AppColor {
    static let background = Color(.systemBackground)
    static let surface = Color(.secondarySystemBackground)
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let accent = Color(red: 0.20, green: 0.55, blue: 0.34)
}
