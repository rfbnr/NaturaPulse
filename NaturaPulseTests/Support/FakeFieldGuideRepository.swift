//
//  FakeFieldGuideRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
@testable import NaturaPulse

final class FakeFieldGuideRepository: FieldGuideRepository {
    var savedResult: Result<[Species], AppError> = .success([])
    var savedFlag = false
    var savedSpeciesArgID: Int?
    var removedID: Int?

    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        savedResult.publisher.eraseToAnyPublisher()
    }

    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never> {
        Just(savedFlag).eraseToAnyPublisher()
    }

    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        savedSpeciesArgID = species.id
        return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        removedID = id
        return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}
