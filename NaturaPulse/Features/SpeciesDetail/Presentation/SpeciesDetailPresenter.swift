//
//  SpeciesDetailPresenter.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import Observation

@Observable
@MainActor
final class SpeciesDetailPresenter {
    let species: Species
    private(set) var profileState: LoadState<SpeciesProfile> = .idle
    private(set) var weatherState: LoadState<WeatherContext> = .idle

    @ObservationIgnored private let getSpeciesProfile: GetSpeciesProfileUseCase
    @ObservationIgnored private let getWeatherContext: GetWeatherContextUseCase
    @ObservationIgnored private var profileCancellable: AnyCancellable?
    @ObservationIgnored private var weatherCancellable: AnyCancellable?

    init(
        species: Species,
        getSpeciesProfile: GetSpeciesProfileUseCase,
        getWeatherContext: GetWeatherContextUseCase
    ) {
        self.species = species
        self.getSpeciesProfile = getSpeciesProfile
        self.getWeatherContext = getWeatherContext
    }

    func onAppear() {
        if case .idle = profileState { loadProfile() }
        if case .idle = weatherState { loadWeather() }
    }

    func retry() {
        if case .failed = profileState { loadProfile() }
        if case .failed = weatherState { loadWeather() }
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
