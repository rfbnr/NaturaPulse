//
//  GetWeatherContextUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public struct GetWeatherContextUseCase {
    private let repository: WeatherRepository

    public init(repository: WeatherRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        location: Location
    ) -> AnyPublisher<WeatherContext, AppError> {
        repository.context(at: location)
    }
}
