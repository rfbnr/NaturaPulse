//
//  ObserveIsSavedUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

public struct ObserveIsSavedUseCase {
    private let repository: FieldGuideRepository

    public init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    public func callAsFunction(
        id: Species.ID
    ) -> AnyPublisher<Bool, Never> {
        repository.isSaved(id)
    }
}
