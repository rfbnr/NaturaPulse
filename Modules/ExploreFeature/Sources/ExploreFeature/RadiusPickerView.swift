//
//  RadiusPickerView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

struct RadiusPickerView: View {
    let presenter: ExplorePresenter

    private static let options: [Double] = [5, 10, 25, 50]

    private func label(for kilometers: Double) -> String {
        "\(Int(kilometers)) km"
    }

    var body: some View {
        Menu {
            ForEach(Self.options, id: \.self) { kilometers in
                Button {
                    presenter.select(radius: .km(kilometers))
                } label: {
                    if presenter.radius.kilometers == kilometers {
                        Label(label(for: kilometers), systemImage: "checkmark")
                    } else {
                        Text(label(for: kilometers))
                    }
                }
            }
        } label: {
            Label(label(for: presenter.radius.kilometers), systemImage: "dot.radiowaves.left.and.right")
                .font(AppTypography.caption())
                .foregroundStyle(AppColor.accent)
        }
        .accessibilityLabel("Search radius")
        .accessibilityValue(label(for: presenter.radius.kilometers))
    }
}
