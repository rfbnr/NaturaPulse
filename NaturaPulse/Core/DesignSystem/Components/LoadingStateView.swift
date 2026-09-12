//
//  LoadingStateView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

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
        .shimmer()
        .accessibilityLabel("Loading content")
    }

    private var placeholderCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            RoundedRectangle(cornerRadius: AppSpacing.sm)
                .fill(AppColor.surface)
                .frame(height: 140)
            
            RoundedRectangle(cornerRadius: AppSpacing.xs)
                .fill(AppColor.surface)
                .frame(width: 180, height: 16)
            
            RoundedRectangle(cornerRadius: AppSpacing.xs)
                .fill(AppColor.surface)
                .frame(width: 110, height: 12)
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.md))
    }
}

#Preview {
    LoadingStateView()
        .background(AppColor.background)
}
