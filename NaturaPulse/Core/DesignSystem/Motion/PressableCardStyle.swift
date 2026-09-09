//
//  PressableCardStyle.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import SwiftUI

/// A plain button style that adds a subtle press-scale to tappable cards.
/// Honors Reduced Motion via `ReducedMotion.isEnabled`: when enabled, no
/// scaling and no animation are applied.
struct PressableCardStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        let reduced = ReducedMotion.isEnabled
        return configuration.label
            .scaleEffect(reduced ? 1 : (configuration.isPressed ? 0.98 : 1))
            .animation(reduced ? nil : .spring(response: 0.3, dampingFraction: 0.7),
                       value: configuration.isPressed)
    }
}
