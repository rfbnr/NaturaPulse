//
//  ErrorStateView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: AppSpacing.sm) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: AppSpacing.xl))
                .foregroundStyle(AppColor.secondaryText)
                .padding(.bottom, AppSpacing.xs)

            Text(message)
                .font(AppTypography.body())
                .foregroundStyle(AppColor.primaryText)
                .multilineTextAlignment(.center)

            Button(action: retry) {
                Text("Retry")
                    .font(AppTypography.headline())
            }
            .buttonStyle(.borderedProminent)
            .tint(AppColor.accent)
            .accessibilityLabel("Retry")
            .padding(.top, AppSpacing.sm)
        }
        .padding(AppSpacing.lg)
    }
}

#Preview {
    ErrorStateView(
        message: "Something went wrong. Please try again.",
        retry: {}
    )
    .background(AppColor.background)
}
