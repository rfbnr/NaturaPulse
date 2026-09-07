//
//  FieldGuidePlaceholderView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// Placeholder for the Field Guide tab, reserved for a future increment.
struct FieldGuidePlaceholderView: View {
    var body: some View {
        NavigationStack {
            EmptyStateView(
                title: "Coming soon",
                message: "Your saved species will be available in a future update.",
                actionTitle: nil,
                action: nil
            )
            .background(AppColor.background)
            .navigationTitle("Field Guide")
        }
    }
}

#Preview {
    FieldGuidePlaceholderView()
}
