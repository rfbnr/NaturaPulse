//
//  FieldGuideAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

/// Registers the Field Guide feature's dependency graph: the Realm-backed
/// `FieldGuideRepository`, its use cases, and the `FieldGuidePresenter`.
///
/// `FieldGuidePresenter` is `@MainActor`-isolated, so its factory hops onto
/// the main actor via `MainActor.assumeIsolated`. This is safe because the
/// composition root (`AppContainer`, built from `NaturaPulseApp`) always
/// resolves on the main thread; `assumeIsolated` traps otherwise, which is
/// an acceptable failure mode at the composition root.
final class FieldGuideAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FieldGuideRepository.self) { r in
            FieldGuideRepositoryImpl(realmProvider: r.resolveRequired(RealmProvider.self))
        }
        .inObjectScope(.container)

        container.register(GetSavedSpeciesUseCase.self) { r in
            GetSavedSpeciesUseCase(repository: r.resolveRequired(FieldGuideRepository.self))
        }

        container.register(ToggleFavoriteUseCase.self) { r in
            ToggleFavoriteUseCase(repository: r.resolveRequired(FieldGuideRepository.self))
        }

        container.register(RemoveSavedSpeciesUseCase.self) { r in
            RemoveSavedSpeciesUseCase(repository: r.resolveRequired(FieldGuideRepository.self))
        }

        container.register(ObserveIsSavedUseCase.self) { r in
            ObserveIsSavedUseCase(repository: r.resolveRequired(FieldGuideRepository.self))
        }

        container.register(ObserveSavedSpeciesIDsUseCase.self) { r in
            ObserveSavedSpeciesIDsUseCase(repository: r.resolveRequired(FieldGuideRepository.self))
        }

        container.register(FieldGuidePresenter.self) { r in
            MainActor.assumeIsolated {
                FieldGuidePresenter(
                    getSavedSpecies: r.resolveRequired(GetSavedSpeciesUseCase.self),
                    removeSavedSpecies: r.resolveRequired(RemoveSavedSpeciesUseCase.self)
                )
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
            preconditionFailure("FieldGuideAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
