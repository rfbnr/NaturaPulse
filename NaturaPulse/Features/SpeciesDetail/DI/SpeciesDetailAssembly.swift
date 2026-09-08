//
//  SpeciesDetailAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

/// Registers the Species Detail feature's dependency graph: `GetSpeciesProfileUseCase`
/// (reusing Explore's `SpeciesRepository` registration) and the
/// `SpeciesDetailPresenterFactory`.
///
/// `SpeciesDetailPresenter` needs a runtime `Species` value, so this assembly
/// registers a factory rather than a presenter instance directly. The
/// factory's `make(species:)` is `@MainActor`, matching the presenter's own
/// isolation; the factory struct itself carries no actor isolation, so
/// resolving it does not require `MainActor.assumeIsolated`.
///
/// `GetWeatherContextUseCase` is registered by `ExploreAssembly`, and
/// `ToggleFavoriteUseCase`/`ObserveIsSavedUseCase` are registered by
/// `FieldGuideAssembly`; all are resolved here from the shared container.
final class SpeciesDetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GetSpeciesProfileUseCase.self) { r in
            GetSpeciesProfileUseCase(repository: r.resolveRequired(SpeciesRepository.self))
        }

        container.register(SpeciesDetailPresenterFactory.self) { r in
            SpeciesDetailPresenterFactory(
                getSpeciesProfile: r.resolveRequired(GetSpeciesProfileUseCase.self),
                getWeatherContext: r.resolveRequired(GetWeatherContextUseCase.self),
                toggleFavorite: r.resolveRequired(ToggleFavoriteUseCase.self),
                observeIsSaved: r.resolveRequired(ObserveIsSavedUseCase.self)
            )
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
            preconditionFailure("SpeciesDetailAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
