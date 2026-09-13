//
//  SearchAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class SearchAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SearchSpeciesUseCase.self) { resolver in
            SearchSpeciesUseCase(repository: resolver.resolveRequired(SpeciesRepository.self))
        }

        container.register(SearchPresenter.self) { resolver in
            MainActor.assumeIsolated {
                SearchPresenter(
                    searchSpecies: resolver.resolveRequired(SearchSpeciesUseCase.self),
                    toggleFavorite: resolver.resolveRequired(ToggleFavoriteUseCase.self),
                    observeSavedIDs: resolver.resolveRequired(ObserveSavedSpeciesIDsUseCase.self)
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
            preconditionFailure("SearchAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
