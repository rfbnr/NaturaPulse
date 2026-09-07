//
//  SearchPlaceholderView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

/// Placeholder for the Search tab, reserved for a future increment.
struct SearchPlaceholderView: View {
    var body: some View {
        NavigationStack {
            EmptyStateView(
                title: "Coming soon",
                message: "Species search will be available in a future update.",
                actionTitle: nil,
                action: nil
            )
            .background(AppColor.background)
            .navigationTitle("Search")
        }
    }
}

#Preview {
    SearchPlaceholderView()
}
