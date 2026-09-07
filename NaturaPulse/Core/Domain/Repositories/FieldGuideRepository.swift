//
//  FieldGuideRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

protocol FieldGuideRepository {
    func savedSpecies() -> AnyPublisher<[Species], AppError>
    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never>
    func save(_ species: Species) -> AnyPublisher<Void, AppError>
    func remove(id: Species.ID) -> AnyPublisher<Void, AppError>
}
