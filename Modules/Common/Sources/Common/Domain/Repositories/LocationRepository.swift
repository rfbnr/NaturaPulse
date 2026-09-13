//
//  LocationRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public protocol LocationRepository {
    func searchLocations(query: String) -> AnyPublisher<[Location], AppError>
}
