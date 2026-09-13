//
//  WeatherRepositoryImpl.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

final class WeatherRepositoryImpl: WeatherRepository {
    private let dataSource: WeatherRemoteDataSource
    private let now: () -> Date

    init(
        dataSource: WeatherRemoteDataSource,
        now: @escaping () -> Date = Date.init
    ) {
        self.dataSource = dataSource
        self.now = now
    }

    func context(
        at location: Location
    ) -> AnyPublisher<WeatherContext, AppError> {
        let forecast = dataSource.forecast(
            latitude: location.latitude,
            longitude: location.longitude
        )
        
        let airQuality = dataSource.airQuality(
            latitude: location.latitude,
            longitude: location.longitude
        )
            .map { Optional($0) }
            .replaceError(with: nil)
            .setFailureType(to: NetworkError.self)

        return Publishers.Zip(forecast, airQuality)
            .map { [now] forecast, airQuality in
                WeatherContextMapper.map(
                    forecast: forecast,
                    airQuality: airQuality,
                    capturedAt: now()
                )
            }
            .mapError { $0.toAppError() }
            .eraseToAnyPublisher()
    }
}
