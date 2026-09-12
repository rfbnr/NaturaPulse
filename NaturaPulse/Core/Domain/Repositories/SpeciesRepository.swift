//
//  SpeciesRepository.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine

protocol SpeciesRepository {
    func getNearbySpecies(
        at location: Location,
        radius: Distance
    ) -> AnyPublisher<[Species], AppError>
    func searchSpecies(
        query: String
    ) -> AnyPublisher<[Species], AppError>
    func getSpeciesProfile(
        id: Species.ID
    ) -> AnyPublisher<SpeciesProfile, AppError>
}
