//
//  SpeciesDetailPresenterFactory.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

/// Builds a `SpeciesDetailPresenter` for a runtime `Species`.
///
/// `SpeciesDetailPresenter` needs a `Species` value that only exists once the
/// user has selected one (e.g. from Explore or Search results), so DI cannot
/// register a ready-made presenter instance. Instead, the composition root
/// registers this factory, which holds the presenter's other dependencies
/// and produces a presenter on demand.
struct SpeciesDetailPresenterFactory {
    private let getSpeciesProfile: GetSpeciesProfileUseCase
    private let getWeatherContext: GetWeatherContextUseCase

    init(
        getSpeciesProfile: GetSpeciesProfileUseCase,
        getWeatherContext: GetWeatherContextUseCase
    ) {
        self.getSpeciesProfile = getSpeciesProfile
        self.getWeatherContext = getWeatherContext
    }

    @MainActor
    func make(species: Species) -> SpeciesDetailPresenter {
        SpeciesDetailPresenter(
            species: species,
            getSpeciesProfile: getSpeciesProfile,
            getWeatherContext: getWeatherContext
        )
    }
}
