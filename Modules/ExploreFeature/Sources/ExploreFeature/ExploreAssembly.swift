//
//  ExploreAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class ExploreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GBIFRemoteDataSource.self) { resolver in
            DefaultGBIFRemoteDataSource(
                apiClient: resolver.resolveRequired(APIClient.self)
            )
        }

        container.register(WeatherRemoteDataSource.self) { resolver in
            DefaultWeatherRemoteDataSource(
                apiClient: resolver.resolveRequired(APIClient.self)
            )
        }

        container.register(GeocodingRemoteDataSource.self) { resolver in
            DefaultGeocodingRemoteDataSource(
                apiClient: resolver.resolveRequired(APIClient.self)
            )
        }

        container.register(SpeciesRepository.self) { resolver in
            SpeciesRepositoryImpl(
                dataSource: resolver.resolveRequired(GBIFRemoteDataSource.self)
            )
        }

        container.register(WeatherRepository.self) { resolver in
            WeatherRepositoryImpl(
                dataSource: resolver.resolveRequired(WeatherRemoteDataSource.self)
            )
        }

        container.register(LocationRepository.self) { resolver in
            LocationRepositoryImpl(
                dataSource: resolver.resolveRequired(GeocodingRemoteDataSource.self)
            )
        }

        container.register(GetNearbySpeciesUseCase.self) { resolver in
            GetNearbySpeciesUseCase(repository: resolver.resolveRequired(SpeciesRepository.self))
        }

        container.register(GetWeatherContextUseCase.self) { resolver in
            GetWeatherContextUseCase(
                repository: resolver.resolveRequired(WeatherRepository.self)
            )
        }

        container.register(SearchLocationUseCase.self) { resolver in
            SearchLocationUseCase(
                repository: resolver.resolveRequired(LocationRepository.self)
            )
        }

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

private extension Resolver {
    func resolveRequired<Service>(
        _ serviceType: Service.Type
    ) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("ExploreAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        
        return resolved
    }
}
