//
//  CommonAssembly.swift
//  Common
//
//  Created by Ridwan Febnur AR on 13/09/26.
//

import Swinject

public final class CommonAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(APIClient.self) { _ in
            AlamofireAPIClient()
        }
        .inObjectScope(.container)

        container.register(RealmProvider.self) { _ in
            DefaultRealmProvider()
        }
        .inObjectScope(.container)

        container.register(GBIFRemoteDataSource.self) { resolver in
            DefaultGBIFRemoteDataSource(apiClient: resolver.resolveRequired(APIClient.self))
        }

        container.register(WeatherRemoteDataSource.self) { resolver in
            DefaultWeatherRemoteDataSource(apiClient: resolver.resolveRequired(APIClient.self))
        }

        container.register(GeocodingRemoteDataSource.self) { resolver in
            DefaultGeocodingRemoteDataSource(apiClient: resolver.resolveRequired(APIClient.self))
        }

        container.register(SpeciesRepository.self) { resolver in
            SpeciesRepositoryImpl(dataSource: resolver.resolveRequired(GBIFRemoteDataSource.self))
        }

        container.register(WeatherRepository.self) { resolver in
            WeatherRepositoryImpl(dataSource: resolver.resolveRequired(WeatherRemoteDataSource.self))
        }

        container.register(LocationRepository.self) { resolver in
            LocationRepositoryImpl(dataSource: resolver.resolveRequired(GeocodingRemoteDataSource.self))
        }

        container.register(FieldGuideRepository.self) { resolver in
            FieldGuideRepositoryImpl(realmProvider: resolver.resolveRequired(RealmProvider.self))
        }
        .inObjectScope(.container)

        container.register(GetNearbySpeciesUseCase.self) { resolver in
            GetNearbySpeciesUseCase(repository: resolver.resolveRequired(SpeciesRepository.self))
        }

        container.register(GetWeatherContextUseCase.self) { resolver in
            GetWeatherContextUseCase(repository: resolver.resolveRequired(WeatherRepository.self))
        }

        container.register(SearchLocationUseCase.self) { resolver in
            SearchLocationUseCase(repository: resolver.resolveRequired(LocationRepository.self))
        }

        container.register(SearchSpeciesUseCase.self) { resolver in
            SearchSpeciesUseCase(repository: resolver.resolveRequired(SpeciesRepository.self))
        }

        container.register(GetSpeciesProfileUseCase.self) { resolver in
            GetSpeciesProfileUseCase(repository: resolver.resolveRequired(SpeciesRepository.self))
        }

        container.register(GetSavedSpeciesUseCase.self) { resolver in
            GetSavedSpeciesUseCase(repository: resolver.resolveRequired(FieldGuideRepository.self))
        }

        container.register(ToggleFavoriteUseCase.self) { resolver in
            ToggleFavoriteUseCase(repository: resolver.resolveRequired(FieldGuideRepository.self))
        }

        container.register(RemoveSavedSpeciesUseCase.self) { resolver in
            RemoveSavedSpeciesUseCase(repository: resolver.resolveRequired(FieldGuideRepository.self))
        }

        container.register(ObserveIsSavedUseCase.self) { resolver in
            ObserveIsSavedUseCase(repository: resolver.resolveRequired(FieldGuideRepository.self))
        }

        container.register(ObserveSavedSpeciesIDsUseCase.self) { resolver in
            ObserveSavedSpeciesIDsUseCase(repository: resolver.resolveRequired(FieldGuideRepository.self))
        }
    }
}
