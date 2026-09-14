//
//  AppRootView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import ExploreFeature
import FieldGuideFeature
import SearchFeature
import SwiftUI

struct AppRootView: View {
    @Environment(\.resolver) private var resolver

    var body: some View {
        TabView {
            ExploreView(presenter: resolver.resolveRequired(ExplorePresenter.self))
                .tabItem {
                    Label("Explore", systemImage: "leaf.fill")
                }

            SearchView(presenter: resolver.resolveRequired(SearchPresenter.self))
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            FieldGuideView(presenter: resolver.resolveRequired(FieldGuidePresenter.self))
                .tabItem {
                    Label("Field Guide", systemImage: "book.closed.fill")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "person.crop.circle")
                }
        }
        .tint(AppColor.accent)
    }
}

#Preview {
    AppRootView()
        .environment(\.resolver, AppContainer().resolver)
}
