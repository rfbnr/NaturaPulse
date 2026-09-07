//
//  WeatherRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

protocol WeatherRepository {
    func context(at location: Location) -> AnyPublisher<WeatherContext, AppError>
}
