//
//  FakeWeatherRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
@testable import NaturaPulse

final class FakeWeatherRepository: WeatherRepository {
    var result: Result<WeatherContext, AppError> = .success(
        WeatherContext(
            temperatureCelsius: 28,
            relativeHumidity: 60,
            precipitation: 0,
            weatherCode: 0,
            pm25: 20,
            capturedAt: Date()
        )
    )

    func context(at location: Location) -> AnyPublisher<WeatherContext, AppError> {
        result.publisher.eraseToAnyPublisher()
    }
}
