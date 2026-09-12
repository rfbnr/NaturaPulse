//
//  Typography.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

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
