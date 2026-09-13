//
//  FakeWeatherRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import Common

public final class FakeWeatherRepository: WeatherRepository {
    public var result: Result<WeatherContext, AppError> = .success(
        WeatherContext(
            temperatureCelsius: 28,
            relativeHumidity: 60,
            precipitation: 0,
            weatherCode: 0,
            pm25: 20,
            capturedAt: Date()
        )
    )

    public var contextCallCount = 0

    public init() {}

    public func context(at location: Location) -> AnyPublisher<WeatherContext, AppError> {
        contextCallCount += 1
        return result.publisher.eraseToAnyPublisher()
    }
}
