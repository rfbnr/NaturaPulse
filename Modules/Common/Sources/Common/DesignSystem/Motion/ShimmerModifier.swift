//
//  ShimmerModifier.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import SwiftUI
import UIKit

struct ShimmerModifier: ViewModifier {
    @State private var reducedMotion = ReducedMotion.isEnabled
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        shimmering(content)
            .onReceive(NotificationCenter.default.publisher(
                for: UIAccessibility.reduceMotionStatusDidChangeNotification
            )) { _ in
                reducedMotion = ReducedMotion.isEnabled
            }
    }

    @ViewBuilder
    private func shimmering(_ content: Content) -> some View {
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

public extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}
