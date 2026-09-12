//
//  ObserveIsSavedUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct ObserveIsSavedUseCase {
    private let repository: FieldGuideRepository

    init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    func callAsFunction(
        id: Species.ID
    ) -> AnyPublisher<Bool, Never> {
        repository.isSaved(id)
    }
}
