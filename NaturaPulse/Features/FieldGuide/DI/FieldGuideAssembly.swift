//
//  FieldGuideAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class FieldGuideAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FieldGuideRepository.self) { r in
            FieldGuideRepositoryImpl(
                realmProvider: r.resolveRequired(RealmProvider.self)
            )
        }
        .inObjectScope(.container)

        container.register(GetSavedSpeciesUseCase.self) { r in
            GetSavedSpeciesUseCase(
                repository: r.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(ToggleFavoriteUseCase.self) { r in
            ToggleFavoriteUseCase(
                repository: r.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(RemoveSavedSpeciesUseCase.self) { r in
            RemoveSavedSpeciesUseCase(
                repository: r.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(ObserveIsSavedUseCase.self) { r in
            ObserveIsSavedUseCase(
                repository: r.resolveRequired(FieldGuideRepository.self)
            )
        }

        container.register(ObserveSavedSpeciesIDsUseCase.self) { r in
            ObserveSavedSpeciesIDsUseCase(
                repository: r.resolveRequired(FieldGuideRepository.self)
            )
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
