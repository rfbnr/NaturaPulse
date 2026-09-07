//
//  AppRootView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject
import SwiftUI

/// The environment key carrying the app's DI `Resolver`. `NaturaPulseApp`
/// injects the real `AppContainer.resolver`; the default value here is an
/// empty container used only as a safety net (e.g. previews that forget to
/// inject one), never expected to resolve anything real.
private struct ResolverKey: EnvironmentKey {
    static let defaultValue: Resolver = Container()
}

extension EnvironmentValues {
    var resolver: Resolver {
        get { self[ResolverKey.self] }
        set { self[ResolverKey.self] = newValue }
    }
}

/// The app's composition-root view: a four-tab shell backed by the
/// dependency graph resolved from the environment's `Resolver`.
struct AppRootView: View {
    @Environment(\.resolver) private var resolver

    var body: some View {
        TabView {
            ExploreView(presenter: resolver.resolveRequired(ExplorePresenter.self))
                .tabItem {
                    Label("Explore", systemImage: "leaf.fill")
                }

            SearchPlaceholderView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            FieldGuidePlaceholderView()
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

/// Composition-root helper for resolving a required dependency from the
/// environment's resolver without a force-unwrap.
private extension Resolver {
    func resolveRequired<Service>(_ serviceType: Service.Type) -> Service {
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
