//
//  GetWeatherContextUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct GetWeatherContextUseCase {
    private let repository: WeatherRepository

    init(repository: WeatherRepository) {
        self.repository = repository
    }

    func callAsFunction(
        location: Location
    ) -> AnyPublisher<WeatherContext, AppError> {
        repository.context(at: location)
    }
}
