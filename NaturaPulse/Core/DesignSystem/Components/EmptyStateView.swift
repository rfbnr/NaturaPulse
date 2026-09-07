//
//  EmptyStateView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// A generic empty state with an icon, title, message, and an optional
/// call-to-action button. The button is shown only when both `actionTitle`
/// and `action` are provided.
struct EmptyStateView: View {
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "leaf")
                .font(.system(size: AppSpacing.xl))
                .foregroundStyle(AppColor.secondaryText)
                .padding(.bottom, AppSpacing.xs)

            Text(title)
                .font(AppTypography.headline())
                .foregroundStyle(AppColor.primaryText)
                .multilineTextAlignment(.center)

            Text(message)
                .font(AppTypography.body())
                .foregroundStyle(AppColor.secondaryText)
                .multilineTextAlignment(.center)

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(AppTypography.headline())
                }
                .buttonStyle(.borderedProminent)
                .tint(AppColor.accent)
                .padding(.top, AppSpacing.sm)
            }
        }
        .padding(AppSpacing.lg)
    }
}

#Preview {
    EmptyStateView(
        title: "Nothing here yet",
        message: "Explore nearby species to see them appear here.",
        actionTitle: "Explore Now",
        action: {}
    )
    .background(AppColor.background)
}
