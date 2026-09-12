//
//  SpeciesDetailPresenterFactory.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct SpeciesDetailPresenterFactory {
    private let getSpeciesProfile: GetSpeciesProfileUseCase
    private let getWeatherContext: GetWeatherContextUseCase
    private let toggleFavorite: ToggleFavoriteUseCase
    private let observeIsSaved: ObserveIsSavedUseCase

    init(
        getSpeciesProfile: GetSpeciesProfileUseCase,
        getWeatherContext: GetWeatherContextUseCase,
        toggleFavorite: ToggleFavoriteUseCase,
        observeIsSaved: ObserveIsSavedUseCase
    ) {
        self.getSpeciesProfile = getSpeciesProfile
        self.getWeatherContext = getWeatherContext
        self.toggleFavorite = toggleFavorite
        self.observeIsSaved = observeIsSaved
    }

    @MainActor
    func make(species: Species) -> SpeciesDetailPresenter {
        SpeciesDetailPresenter(
            species: species,
            getSpeciesProfile: getSpeciesProfile,
            getWeatherContext: getWeatherContext,
            toggleFavorite: toggleFavorite,
            observeIsSaved: observeIsSaved
        )
    }
}
