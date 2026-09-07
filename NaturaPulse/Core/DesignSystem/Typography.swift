//
//  Typography.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// Semantic typography tokens tied to Dynamic Type text styles so app
/// text scales with the user's preferred content size.
enum AppTypography {
    static func title() -> Font {
        .system(.largeTitle, design: .default, weight: .bold)
    }

    static func headline() -> Font {
        .system(.headline, design: .default, weight: .semibold)
    }

    static func body() -> Font {
        .system(.body, design: .default)
    }

    static func caption() -> Font {
        .system(.caption, design: .default)
    }
}
