//
//  Typography.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

public enum AppTypography {
    public static func title() -> Font {
        .system(.largeTitle, design: .default, weight: .bold)
    }

    public static func headline() -> Font {
        .system(.headline, design: .default, weight: .semibold)
    }

    public static func body() -> Font {
        .system(.body, design: .default)
    }

    public static func caption() -> Font {
        .system(.caption, design: .default)
    }
}
