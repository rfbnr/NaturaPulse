//
//  ExplorePresenter.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Foundation
import Observation

@Observable
@MainActor
final class ExplorePresenter {
    private(set) var location: Location
    private(set) var radius: Distance
    private(set) var speciesState: LoadState<[Species]> = .idle
    private(set) var weatherState: LoadState<WeatherContext> = .idle

    @ObservationIgnored private let getNearbySpecies: GetNearbySpeciesUseCase
    @ObservationIgnored private let getWeatherContext: GetWeatherContextUseCase
    @ObservationIgnored private let searchLocation: SearchLocationUseCase
    @ObservationIgnored private var speciesCancellable: AnyCancellable?
    @ObservationIgnored private var weatherCancellable: AnyCancellable?

    init(
        getNearbySpecies: GetNearbySpeciesUseCase,
        getWeatherContext: GetWeatherContextUseCase,
        searchLocation: SearchLocationUseCase,
        location: Location = .jakarta,
        radius: Distance = .km(10)
    ) {
        self.getNearbySpecies = getNearbySpecies
        self.getWeatherContext = getWeatherContext
        self.searchLocation = searchLocation
        self.location = location
        self.radius = radius
    }

    func onAppear() {
        if case .idle = speciesState { load() }
    }

    func refresh() { load() }

    func retry() { load() }

    func select(location: Location) {
        self.location = location
        load()
    }

    func select(radius: Distance) {
        self.radius = radius
        load()
    }

    private func load() {
        loadSpecies()
        loadWeather()
    }

    private func loadSpecies() {
        let previous: [Species]? = { if case .loaded(let value) = speciesState { return value } else { return nil } }()
        speciesState = .loading(previous: previous)
        speciesCancellable = getNearbySpecies(location: location, radius: radius)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion { self?.speciesState = .failed(error) }
            }, receiveValue: { [weak self] species in
                self?.speciesState = species.isEmpty ? .empty : .loaded(species)
            })
    }

    private func loadWeather() {
        let previous: WeatherContext? = { if case .loaded(let value) = weatherState { return value } else { return nil } }()
        weatherState = .loading(previous: previous)
        weatherCancellable = getWeatherContext(location: location)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion { self?.weatherState = .failed(error) }
            }, receiveValue: { [weak self] context in
                self?.weatherState = .loaded(context)
            })
    }
}
