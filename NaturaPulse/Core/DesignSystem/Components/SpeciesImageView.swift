//
//  SpeciesImageView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Kingfisher
import SwiftUI

struct SpeciesImageView: View {
    let url: URL?
    var height: CGFloat = 180

    var body: some View {
        content
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .clipped()
            .background(AppColor.surface)
    }

    @ViewBuilder
    private var content: some View {
        if let url {
            KFImage(url)
                .placeholder { loadingPlaceholder }
                .resizable()
                .scaledToFill()
        } else {
            unavailableState
        }
    }

    private var loadingPlaceholder: some View {
        ZStack {
            AppColor.surface
            Image(systemName: "leaf")
                .font(.system(size: 32))
                .foregroundStyle(AppColor.secondaryText)
        }
    }

    private var unavailableState: some View {
        ZStack {
            AppColor.surface
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: "leaf.slash")
                    .font(.system(size: 32))
                    .foregroundStyle(AppColor.secondaryText)
                Text("Photo not available")
                    .font(AppTypography.caption())
                    .foregroundStyle(AppColor.secondaryText)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Photo not available")
    }
}
