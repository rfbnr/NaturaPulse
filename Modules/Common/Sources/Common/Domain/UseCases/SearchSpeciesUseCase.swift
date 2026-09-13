//
//  SearchSpeciesUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation

public struct SearchSpeciesUseCase {
    private let repository: SpeciesRepository

    public init(repository: SpeciesRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        query: String
    ) -> AnyPublisher<[Species], AppError> {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard trimmed.count >= 2 else {
            return Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
        }
        
        return repository.searchSpecies(query: trimmed)
    }
}
