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
        KFImage(url)
            .placeholder { placeholder }
            .resizable()
            .scaledToFill()
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .clipped()
            .background(AppColor.surface)
    }

    private var placeholder: some View {
        ZStack {
            AppColor.surface
            Image(systemName: "leaf")
                .font(.system(size: 32))
                .foregroundStyle(AppColor.secondaryText)
        }
        .frame(height: height)
        .frame(maxWidth: .infinity)
    }
}
