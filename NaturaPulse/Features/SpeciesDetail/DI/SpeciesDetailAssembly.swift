//
//  SpeciesDetailAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class SpeciesDetailAssembly: Assembly {
    func assemble(
        container: Container
    ) {
        container.register(GetSpeciesProfileUseCase.self) { resolver in
            GetSpeciesProfileUseCase(
                repository: resolver.resolveRequired(SpeciesRepository.self)
            )
        }

        container.register(SpeciesDetailPresenterFactory.self) { resolver in
            SpeciesDetailPresenterFactory(
                getSpeciesProfile: resolver.resolveRequired(GetSpeciesProfileUseCase.self),
                getWeatherContext: resolver.resolveRequired(GetWeatherContextUseCase.self),
                toggleFavorite: resolver.resolveRequired(ToggleFavoriteUseCase.self),
                observeIsSaved: resolver.resolveRequired(ObserveIsSavedUseCase.self)
            )
        }
        .inObjectScope(.transient)
    }
}

private extension Resolver {
    func resolveRequired<Service>(
        _ serviceType: Service.Type
    ) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("SpeciesDetailAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
