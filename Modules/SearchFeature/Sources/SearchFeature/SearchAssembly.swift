//
//  SearchAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import Swinject

public final class SearchAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
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
