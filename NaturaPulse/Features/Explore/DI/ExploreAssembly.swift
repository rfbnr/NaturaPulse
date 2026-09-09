//
//  ExploreAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

/// Registers the Explore feature's dependency graph: remote data sources,
/// repository implementations, use cases, and the `ExplorePresenter`.
///
/// `ExplorePresenter` is `@MainActor`-isolated, so its factory hops onto
/// the main actor via `MainActor.assumeIsolated`. This is safe because the
/// composition root (`AppContainer`, built from `NaturaPulseApp`) always
/// resolves on the main thread; `assumeIsolated` traps otherwise, which is
/// an acceptable failure mode at the composition root.
final class ExploreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(GBIFRemoteDataSource.self) { r in
            DefaultGBIFRemoteDataSource(apiClient: r.resolveRequired(APIClient.self))
        }

        container.register(WeatherRemoteDataSource.self) { r in
            DefaultWeatherRemoteDataSource(apiClient: r.resolveRequired(APIClient.self))
        }

        container.register(GeocodingRemoteDataSource.self) { r in
            DefaultGeocodingRemoteDataSource(apiClient: r.resolveRequired(APIClient.self))
        }

        container.register(SpeciesRepository.self) { r in
            SpeciesRepositoryImpl(dataSource: r.resolveRequired(GBIFRemoteDataSource.self))
        }

        container.register(WeatherRepository.self) { r in
            WeatherRepositoryImpl(dataSource: r.resolveRequired(WeatherRemoteDataSource.self))
        }

        container.register(LocationRepository.self) { r in
            LocationRepositoryImpl(dataSource: r.resolveRequired(GeocodingRemoteDataSource.self))
        }

        container.register(GetNearbySpeciesUseCase.self) { r in
            GetNearbySpeciesUseCase(repository: r.resolveRequired(SpeciesRepository.self))
        }

        container.register(GetWeatherContextUseCase.self) { r in
            GetWeatherContextUseCase(repository: r.resolveRequired(WeatherRepository.self))
        }

        container.register(SearchLocationUseCase.self) { r in
            SearchLocationUseCase(repository: r.resolveRequired(LocationRepository.self))
        }

        container.register(ExplorePresenter.self) { r in
            MainActor.assumeIsolated {
                ExplorePresenter(
                    getNearbySpecies: r.resolveRequired(GetNearbySpeciesUseCase.self),
                    getWeatherContext: r.resolveRequired(GetWeatherContextUseCase.self),
                    searchLocation: r.resolveRequired(SearchLocationUseCase.self),
                    toggleFavorite: r.resolveRequired(ToggleFavoriteUseCase.self),
                    observeSavedIDs: r.resolveRequired(ObserveSavedSpeciesIDsUseCase.self)
                )
            }
        }
        .inObjectScope(.transient)
    }
}

/// Composition-root helper for resolving a required dependency without a
/// force-unwrap. Missing registrations are a programmer error, so this
/// traps with a clear message rather than silently propagating `nil`.
private extension Resolver {
    func resolveRequired<Service>(_ serviceType: Service.Type) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("ExploreAssembly: failed to resolve \(Service.self). Check assembly registration order.")
        }
        return resolved
    }
}
