//
//  EmptyStateView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

public struct EmptyStateView: View {
    public let title: String
    public let message: String
    public let actionTitle: String?
    public let action: (() -> Void)?

    public init(title: String, message: String, actionTitle: String?, action: (() -> Void)?) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
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
