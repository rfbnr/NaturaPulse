//
//  SpeciesDetailAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import Swinject

public final class SpeciesDetailAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(SpeciesDetailPresenterFactory.self) { resolver in
            SpeciesDetailPresenterFactory(
                getSpeciesProfile: resolver.resolveRequired(GetSpeciesProfileUseCase.self),
                getWeatherContext: resolver.resolveRequired(GetWeatherContextUseCase.self),
                toggleFavorite: resolver.resolveRequired(ToggleFavoriteUseCase.self),
                observeIsSaved: resolver.resolveRequired(ObserveIsSavedUseCase.self)
            )
        }
        .inObjectScope(.transient)

        container.register(SpeciesDetailViewProviding.self) { resolver in
            SpeciesDetailViewProvider(factory: resolver.resolveRequired(SpeciesDetailPresenterFactory.self))
        }
    }
}
