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
        container.register(GetSpeciesProfileUseCase.self) { r in
            GetSpeciesProfileUseCase(
                repository: r.resolveRequired(SpeciesRepository.self)
            )
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
