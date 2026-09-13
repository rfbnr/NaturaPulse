//
//  FakeFieldGuideRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common

public final class FakeFieldGuideRepository: FieldGuideRepository {
    public var savedResult: Result<[Species], AppError> = .success([])
    public var savedFlag = false
    public var savedSpeciesArgID: Int?
    public var removedID: Int?

    public init() {}

    public func savedSpecies() -> AnyPublisher<[Species], AppError> {
        savedResult.publisher.eraseToAnyPublisher()
    }

    public func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never> {
        Just(savedFlag).eraseToAnyPublisher()
    }

    public func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        savedSpeciesArgID = species.id
        return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    public func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        removedID = id
        return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}
