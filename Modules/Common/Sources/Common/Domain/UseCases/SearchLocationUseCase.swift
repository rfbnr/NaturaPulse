//
//  SearchLocationUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

public struct SearchLocationUseCase {
    private let repository: LocationRepository

    public init(repository: LocationRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        query: String
    ) -> AnyPublisher<[Location], AppError> {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmed.count >= 2 else {
            return Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
        }
        
        return repository.searchLocations(query: trimmed)
    }
}
