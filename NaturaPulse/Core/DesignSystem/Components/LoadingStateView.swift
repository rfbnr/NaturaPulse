//
//  LoadingStateView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// A placeholder loading state made of redacted card shapes, shown while
/// content is being fetched.
struct LoadingStateView: View {
    private let cardCount = 4

    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(0..<cardCount, id: \.self) { _ in
                placeholderCard
            }
        }
        .padding(AppSpacing.md)
        .redacted(reason: .placeholder)
        .accessibilityLabel("Loading content")
    }

    private var placeholderCard: some View {
        RoundedRectangle(cornerRadius: AppSpacing.sm)
            .fill(AppColor.surface)
            .frame(height: AppSpacing.xl * 2)
    }
}

#Preview {
    LoadingStateView()
        .background(AppColor.background)
}
