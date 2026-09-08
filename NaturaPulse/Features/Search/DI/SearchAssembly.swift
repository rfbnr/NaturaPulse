//
//  SearchAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

/// Registers the Search feature's dependency graph: `SearchSpeciesUseCase`
/// (reusing Explore's `SpeciesRepository` registration) and the
/// `SearchPresenter`.
///
/// `SearchPresenter` is `@MainActor`-isolated, so its factory hops onto
/// the main actor via `MainActor.assumeIsolated`. This is safe because the
/// composition root (`AppContainer`, built from `NaturaPulseApp`) always
/// resolves on the main thread; `assumeIsolated` traps otherwise, which is
/// an acceptable failure mode at the composition root.
final class SearchAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SearchSpeciesUseCase.self) { r in
            SearchSpeciesUseCase(repository: r.resolveRequired(SpeciesRepository.self))
        }

        container.register(SearchPresenter.self) { r in
            MainActor.assumeIsolated {
                SearchPresenter(searchSpecies: r.resolveRequired(SearchSpeciesUseCase.self))
            }
        }
        .inObjectScope(.transient)
    }
}

/// Composition-root helper for resolving a required dependency without a
/// force-unwrap. Missing registrations are a programmer error, so this
/// traps with a clear message rather than silently propagating `nil`.
private extension Resolver {
    func resolveRequired<Service>(_ serviceType: Service.Type) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("SearchAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
