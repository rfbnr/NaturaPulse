//
//  ToggleFavoriteUseCase.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

struct ToggleFavoriteUseCase {
    private let repository: FieldGuideRepository

    init(repository: FieldGuideRepository) {
        self.repository = repository
    }

    func callAsFunction(_ species: Species) -> AnyPublisher<Void, AppError> {
        repository.isSaved(species.id)
            .first()
            .setFailureType(to: AppError.self)
            .flatMap { [repository] saved -> AnyPublisher<Void, AppError> in
                saved ? repository.remove(id: species.id) : repository.save(species)
            }
            .eraseToAnyPublisher()
    }
}
