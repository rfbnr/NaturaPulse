//
//  SpeciesDetailPresenter.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common
import Foundation
import Observation

@Observable
@MainActor
public final class SpeciesDetailPresenter {
    let species: Species
    private(set) var profileState: LoadState<SpeciesProfile> = .idle
    private(set) var weatherState: LoadState<WeatherContext> = .idle
    private(set) var isSaved: Bool = false

    @ObservationIgnored private let getSpeciesProfile: GetSpeciesProfileUseCase
    @ObservationIgnored private let getWeatherContext: GetWeatherContextUseCase
    @ObservationIgnored private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    @ObservationIgnored private let observeIsSaved: ObserveIsSavedUseCase
    @ObservationIgnored private var profileCancellable: AnyCancellable?
    @ObservationIgnored private var weatherCancellable: AnyCancellable?
    @ObservationIgnored private var isSavedCancellable: AnyCancellable?
    @ObservationIgnored private var toggleCancellable: AnyCancellable?

    public init(
        species: Species,
        getSpeciesProfile: GetSpeciesProfileUseCase,
        getWeatherContext: GetWeatherContextUseCase,
        toggleFavorite: ToggleFavoriteUseCase,
        observeIsSaved: ObserveIsSavedUseCase
    ) {
        self.species = species
        self.getSpeciesProfile = getSpeciesProfile
        self.getWeatherContext = getWeatherContext
        self.toggleFavoriteUseCase = toggleFavorite
        self.observeIsSaved = observeIsSaved
    }

    func onAppear() {
        if case .idle = profileState { loadProfile() }
        if case .idle = weatherState { loadWeather() }
        
        isSavedCancellable = observeIsSaved(id: species.id)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] saved in
                self?.isSaved = saved
            }
    }

    func retry() {
        if case .failed = profileState { loadProfile() }
        if case .failed = weatherState { loadWeather() }
    }

    func toggleFavorite() {
        toggleCancellable = toggleFavoriteUseCase(species)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    private func loadProfile() {
        profileState = .loading(previous: nil)
        profileCancellable = getSpeciesProfile(id: species.id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion { self?.profileState = .failed(error) }
            }, receiveValue: { [weak self] profile in
                self?.profileState = (profile.summary == nil) ? .empty : .loaded(profile)
            })
    }

    private func loadWeather() {
        guard let coordinate = species.coordinate else {
            weatherState = .idle
            return
        }
        
        let location = Location(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            name: species.commonName ?? species.scientificName,
            country: nil,
            administrativeArea: nil
        )
        
        weatherState = .loading(previous: nil)
        weatherCancellable = getWeatherContext(location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion { self?.weatherState = .failed(error) }
            }, receiveValue: { [weak self] context in
                self?.weatherState = .loaded(context)
            })
    }
}
