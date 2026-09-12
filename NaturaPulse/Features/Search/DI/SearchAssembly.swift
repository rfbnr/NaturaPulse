//
//  SearchAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class SearchAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SearchSpeciesUseCase.self) { r in
            SearchSpeciesUseCase(repository: r.resolveRequired(SpeciesRepository.self))
        }

        container.register(SearchPresenter.self) { r in
            MainActor.assumeIsolated {
                SearchPresenter(
                    searchSpecies: r.resolveRequired(SearchSpeciesUseCase.self),
                    toggleFavorite: r.resolveRequired(ToggleFavoriteUseCase.self),
                    observeSavedIDs: r.resolveRequired(ObserveSavedSpeciesIDsUseCase.self)
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
