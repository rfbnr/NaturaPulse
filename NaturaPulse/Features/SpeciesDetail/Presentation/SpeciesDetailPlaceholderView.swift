//
//  SpeciesDetailPlaceholderView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// A minimal stand-in for the full species detail screen. Shows the
/// species' image and display name; full detail content arrives in a
/// later increment (M4).
struct SpeciesDetailPlaceholderView: View {
    let species: Species

    private var displayName: String {
        species.commonName ?? species.scientificName
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                SpeciesImageView(url: species.image?.url)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.md))

                Text(displayName)
                    .font(AppTypography.title())
                    .foregroundStyle(AppColor.primaryText)

                Text("Full species details arrive in a later update.")
                    .font(AppTypography.body())
                    .foregroundStyle(AppColor.secondaryText)
            }
            .padding(AppSpacing.md)
        }
        .background(AppColor.background)
        .navigationTitle(displayName)
    }
}

#Preview {
    NavigationStack {
        SpeciesDetailPlaceholderView(
            species: Species(
                id: 1,
                scientificName: "Copsychus saularis",
                commonName: "Oriental Magpie Robin",
                kingdom: "Animalia",
                phylum: "Chordata",
                className: "Aves",
                order: "Passeriformes",
                family: "Muscicapidae",
                genus: "Copsychus",
                description: nil,
                image: nil,
                localObservationCount: 3,
                lastObservedAt: nil,
                source: nil
            )
        )
    }
}
