//
//  SpeciesCardView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

struct SpeciesCardView: View {
    let species: Species
    var isSaved: Bool = false
    var onToggleFavorite: (() -> Void)?

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
                        .contentTransition(.numericText())
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
            onToggleFavorite?()
        } label: {
            Image(systemName: isSaved ? "heart.fill" : "heart")
                .font(.system(size: 18))
                .foregroundStyle(isSaved ? AppColor.accent : AppColor.secondaryText)
                .symbolEffect(.bounce, value: isSaved)
        }
        .disabled(onToggleFavorite == nil)
        .accessibilityLabel(
            isSaved
                ? "Remove \(displayName) from Field Guide"
                : "Add \(displayName) to Field Guide"
        )
        .accessibilityHint(onToggleFavorite == nil ? "Not available yet" : "")
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
