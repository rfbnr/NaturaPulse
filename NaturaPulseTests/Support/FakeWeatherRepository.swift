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

    var contextCallCount = 0

    func context(at location: Location) -> AnyPublisher<WeatherContext, AppError> {
        contextCallCount += 1
        return result.publisher.eraseToAnyPublisher()
    }
}
