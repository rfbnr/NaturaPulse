//
//  FieldGuideAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class FieldGuideAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FieldGuideRepository.self) { resolver in
            FieldGuideRepositoryImpl(
                realmProvider: resolver.resolveRequired(RealmProvider.self)
            )
        }
        .inObjectScope(.container)

        container.register(GetSavedSpeciesUseCase.self) { resolver in
            GetSavedSpeciesUseCase(
                repository: resolver.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(ToggleFavoriteUseCase.self) { resolver in
            ToggleFavoriteUseCase(
                repository: resolver.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(RemoveSavedSpeciesUseCase.self) { resolver in
            RemoveSavedSpeciesUseCase(
                repository: resolver.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(ObserveIsSavedUseCase.self) { resolver in
            ObserveIsSavedUseCase(
                repository: resolver.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(ObserveSavedSpeciesIDsUseCase.self) { resolver in
            ObserveSavedSpeciesIDsUseCase(
                repository: resolver.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(FieldGuidePresenter.self) { resolver in
            MainActor.assumeIsolated {
                FieldGuidePresenter(
                    getSavedSpecies: resolver.resolveRequired(GetSavedSpeciesUseCase.self),
                    removeSavedSpecies: resolver.resolveRequired(RemoveSavedSpeciesUseCase.self)
                )
            }
        }
        .inObjectScope(.transient)
    }
}

private extension Resolver {
    func resolveRequired<Service>(
        _ serviceType: Service.Type
    ) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("FieldGuideAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
