//
//  AppRootView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject
import SwiftUI

private struct ResolverKey: EnvironmentKey {
    static let defaultValue: Resolver = Container()
}

extension EnvironmentValues {
    var resolver: Resolver {
        get { self[ResolverKey.self] }
        set { self[ResolverKey.self] = newValue }
    }
}

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

private extension Resolver {
    func resolveRequired<Service>(
        _ serviceType: Service.Type
    ) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("AppRootView: failed to resolve \(Service.self). Check DI registration.")
        }
        return resolved
    }
}

#Preview {
    AppRootView()
        .environment(\.resolver, AppContainer().resolver)
}
