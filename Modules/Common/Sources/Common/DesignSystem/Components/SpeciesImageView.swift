//
//  SpeciesImageView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Kingfisher
import SwiftUI

public struct SpeciesImageView: View {
    public let url: URL?
    public var height: CGFloat = 180

    public init(url: URL?, height: CGFloat = 180) {
        self.url = url
        self.height = height
    }

    public var body: some View {
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
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: "leaf")
                    .font(.system(size: 32))
                    .foregroundStyle(AppColor.secondaryText)
                Text("species.photo_loading".localized)
                    .font(AppTypography.caption())
                    .foregroundStyle(AppColor.secondaryText)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("species.photo_loading".localized)
    }

    private var unavailableState: some View {
        ZStack {
            AppColor.surface
            VStack(spacing: AppSpacing.xs) {
                Image(systemName: "leaf.slash")
                    .font(.system(size: 32))
                    .foregroundStyle(AppColor.secondaryText)
                Text("species.photo_unavailable".localized)
                    .font(AppTypography.caption())
                    .foregroundStyle(AppColor.secondaryText)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("species.photo_unavailable".localized)
    }
}
