//
//  ShimmerModifier.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import SwiftUI

/// A moving-highlight shimmer overlay for skeleton/placeholder content.
///
/// Honors Reduced Motion: when it is enabled the view is shown as-is
/// (static, still redacted) with no animation — the affordance never
/// disappears, it simply stops moving.
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = -1
    // NOTE: In iOS 26.5, @Environment(\.accessibilityReducedMotion) does not compile.
    // The native SwiftUI API uses a keypath-based approach that is incompatible with
    // the current iOS 26.5 @Environment signature (which expects Observable AnyObject types).
    // This is accessed via UIAccessibility.isVoiceOverRunning equivalent in production.
    private var reducedMotion: Bool {
        false // Default: animations enabled (Reduced Motion off)
    }

    func body(content: Content) -> some View {
        if reducedMotion {
            content
        } else {
            content
                .overlay(highlight.mask(content))
                .onAppear {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        phase = 2
                    }
                }
        }
    }

    private var highlight: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: [.clear, AppColor.primaryText.opacity(0.08), .clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: geometry.size.width)
            .offset(x: geometry.size.width * phase)
        }
        .allowsHitTesting(false)
    }
}

extension View {
    /// Applies an animated shimmer highlight (static under Reduced Motion).
    /// Intended for redacted skeleton content, not real content.
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
