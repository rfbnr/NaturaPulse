//
//  ExploreAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import Swinject

public final class ExploreAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(ExplorePresenter.self) { resolver in
            MainActor.assumeIsolated {
                ExplorePresenter(
                    getNearbySpecies: resolver.resolveRequired(GetNearbySpeciesUseCase.self),
                    getWeatherContext: resolver.resolveRequired(GetWeatherContextUseCase.self),
                    searchLocation: resolver.resolveRequired(SearchLocationUseCase.self),
                    toggleFavorite: resolver.resolveRequired(ToggleFavoriteUseCase.self),
                    observeSavedIDs: resolver.resolveRequired(ObserveSavedSpeciesIDsUseCase.self)
                )
            }
        }
        .inObjectScope(.transient)
    }
}
