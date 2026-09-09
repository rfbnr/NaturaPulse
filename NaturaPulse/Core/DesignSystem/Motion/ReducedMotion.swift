//
//  ReducedMotion.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import UIKit

/// Single source of truth for the system "Reduce Motion" accessibility
/// setting. Read from the View layer only. In this SDK the SwiftUI
/// `@Environment(\.accessibilityReducedMotion)` key does not resolve, so the
/// motion primitives read the setting through UIKit here instead.
enum ReducedMotion {
    static var isEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
}
