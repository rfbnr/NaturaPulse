//
//  SpeciesCardView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// A card summarizing one nearby species: image, name, and local record
/// count. The favorite (♡) button is a visual affordance only in this
/// increment — it is disabled and does not persist anything.
struct SpeciesCardView: View {
    let species: Species

    private var displayName: String {
        species.commonName ?? species.scientificName
    }

    private var showsScientificName: Bool {
        species.commonName != nil
    }

    private var recordsLabel: String {
        let count = species.localObservationCount
        return count == 1 ? "1 local record" : "\(count) local records"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SpeciesImageView(url: species.image?.url)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.sm))
                .accessibilityHidden(true)

            HStack(alignment: .top, spacing: AppSpacing.sm) {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(displayName)
                        .font(AppTypography.headline())
                        .foregroundStyle(AppColor.primaryText)

                    if showsScientificName {
                        Text(species.scientificName)
                            .font(AppTypography.caption())
                            .italic()
                            .foregroundStyle(AppColor.secondaryText)
                    }

                    Text(recordsLabel)
                        .font(AppTypography.caption())
                        .foregroundStyle(AppColor.secondaryText)
                }
                .accessibilityElement(children: .combine)

                Spacer(minLength: AppSpacing.sm)

                favoriteButton
            }
        }
        .padding(AppSpacing.md)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: AppSpacing.md))
    }

    private var favoriteButton: some View {
        Button {
            // Visual affordance only this increment; favoriting is not
            // implemented yet and must not persist anything.
        } label: {
            Image(systemName: "heart")
                .font(.system(size: 18))
                .foregroundStyle(AppColor.secondaryText)
        }
        .disabled(true)
        .accessibilityLabel("Add \(displayName) to favorites")
        .accessibilityHint("Not available yet")
    }
}

#Preview {
    SpeciesCardView(
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
    .padding(AppSpacing.md)
    .background(AppColor.background)
}
