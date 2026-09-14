//
//  AboutView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import SwiftUI

struct AboutView: View {
    private let techStack = ["SwiftUI", "Combine", "Alamofire", "Realm", "Swinject", "Kingfisher", "SwiftLint"]
    private let dataSources = [
        ("GBIF", "Species occurrence and taxonomy data."),
        ("Open-Meteo", "Weather forecast and air-quality data.")
    ]
    private let techStackColumns = [GridItem(.adaptive(minimum: 88), spacing: AppSpacing.sm)]
    private let appDescription = """
    NaturaPulse helps you notice the nature around you: nearby species \
    observations paired with the weather and air quality of the moment, \
    so every walk feels a little more alive.
    """

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    profile

                    section(title: "About NaturaPulse") {
                        Text(appDescription)
                            .font(AppTypography.body())
                            .foregroundStyle(AppColor.secondaryText)
                    }

                    section(title: "Technology stack") {
                        LazyVGrid(columns: techStackColumns, alignment: .leading, spacing: AppSpacing.sm) {
                            ForEach(techStack, id: \.self) { item in
                                Text(item)
                                    .font(AppTypography.caption())
                                    .foregroundStyle(AppColor.primaryText)
                                    .padding(.horizontal, AppSpacing.sm)
                                    .padding(.vertical, AppSpacing.xs)
                                    .background(AppColor.surface)
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    section(title: "Data sources") {
                        VStack(alignment: .leading, spacing: AppSpacing.sm) {
                            ForEach(dataSources, id: \.0) { name, description in
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    Text(name)
                                        .font(AppTypography.headline())
                                        .foregroundStyle(AppColor.primaryText)
                                    
                                    Text(description)
                                        .font(AppTypography.caption())
                                        .foregroundStyle(AppColor.secondaryText)
                                }
                            }
                        }
                    }
                }
                .padding(AppSpacing.md)
            }
            .background(AppColor.background)
            .navigationTitle("About")
        }
    }

    private var profile: some View {
        VStack(spacing: AppSpacing.sm) {
            Image("my_profile")
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .clipShape(Circle())
                .accessibilityHidden(true)

            Text("Ridwan Febnur AR")
                .font(AppTypography.title())
                .foregroundStyle(AppColor.primaryText)

            Text("iOS Developer")
                .font(AppTypography.body())
                .foregroundStyle(AppColor.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, AppSpacing.md)
    }

    private func section<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text(title)
                .font(AppTypography.headline())
                .foregroundStyle(AppColor.primaryText)
            content()
        }
    }
}

#Preview {
    AboutView()
}
