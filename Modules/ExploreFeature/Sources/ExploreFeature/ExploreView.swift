//
//  ExploreView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common
import Swinject
import SwiftUI

public struct ExploreView: View {
    @State var presenter: ExplorePresenter
    @State private var isLocationPickerPresented = false
    @Environment(\.resolver) private var resolver

    public init(presenter: ExplorePresenter) {
        _presenter = State(initialValue: presenter)
    }

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"
        case 17..<22: "Good evening"
        default: "Good night"
        }
    }

    public var body: some View {
        NavigationStack(path: $presenter.path) {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    header

                    if let weather = displayedWeather {
                        WeatherContextCardView(weather: weather)
                    }

                    speciesSection
                }
                .padding(AppSpacing.md)
            }
            .background(AppColor.background)
            .refreshable { presenter.refresh() }
            .onAppear { presenter.onAppear() }
            .sheet(isPresented: $isLocationPickerPresented) {
                LocationPickerView(presenter: presenter)
            }
            .navigationDestination(for: AppRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .speciesDetail(let species):
            resolver.resolveRequired(SpeciesDetailViewProviding.self).makeDetailView(for: species)
        case .locationSearch:
            EmptyView()
        }
    }

    private var displayedWeather: WeatherContext? {
        switch presenter.weatherState {
        case .loaded(let weather):
            weather
        case .loading(let previous):
            previous
        default:
            nil
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(greeting)
                .font(AppTypography.body())
                .foregroundStyle(AppColor.secondaryText)

            HStack(alignment: .center, spacing: AppSpacing.sm) {
                Button {
                    isLocationPickerPresented = true
                } label: {
                    HStack(spacing: AppSpacing.xs) {
                        Text(presenter.location.name)
                            .font(AppTypography.title())
                            .foregroundStyle(AppColor.primaryText)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(AppColor.secondaryText)
                    }
                }
                .accessibilityLabel("Location: \(presenter.location.name)")
                .accessibilityHint("Double tap to change location")

                Spacer()

                RadiusPickerView(presenter: presenter)
            }
        }
    }

    private var speciesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Text("Nearby species")
                    .font(AppTypography.headline())
                    .foregroundStyle(AppColor.primaryText)

                if isReloadingSpecies {
                    ProgressView()
                        .controlSize(.small)
                }

                Spacer()

                if case .loaded(let species) = presenter.speciesState {
                    Text("\(species.count)")
                        .font(AppTypography.caption())
                        .foregroundStyle(AppColor.secondaryText)
                        .contentTransition(.numericText())
                        .animation(.default, value: species.count)
                        .accessibilityLabel("\(species.count) species found")
                }
            }

            speciesContent
        }
    }

    private var isReloadingSpecies: Bool {
        if case .loading(let previous) = presenter.speciesState {
            return previous != nil
        }
        return false
    }

    @ViewBuilder
    private var speciesContent: some View {
        switch presenter.speciesState {
        case .idle:
            LoadingStateView()
        case .loading(let previous):
            if let previous {
                speciesList(previous)
                    .opacity(0.6)
            } else {
                LoadingStateView()
            }
        case .loaded(let species):
            speciesList(species)
        case .empty:
            EmptyStateView(
                title: "Your area is quiet",
                message: "Try a larger radius or a different place",
                actionTitle: "Change radius",
                action: { presenter.select(radius: nextRadius()) }
            )
        case .failed(let error):
            ErrorStateView(message: error.userMessage, retry: presenter.retry)
        }
    }

    private func speciesList(_ species: [Species]) -> some View {
        VStack(spacing: AppSpacing.md) {
            ForEach(species) { item in
                Button {
                    presenter.select(species: item)
                } label: {
                    SpeciesCardView(
                        species: item,
                        isSaved: presenter.isSaved(item.id),
                        onToggleFavorite: {
                            let wasSaved = presenter.isSaved(item.id)
                            presenter.toggleFavorite(item)
                            Haptics.favoriteToggle(wasSaved: wasSaved)
                        }
                    )
                }
                .buttonStyle(PressableCardStyle())
                .accessibilityLabel(item.commonName ?? item.scientificName)
                .accessibilityAction(named: presenter.isSaved(item.id) ? "Remove from Field Guide" : "Add to Field Guide") {
                    let wasSaved = presenter.isSaved(item.id)
                    presenter.toggleFavorite(item)
                    Haptics.favoriteToggle(wasSaved: wasSaved)
                }
            }
        }
    }

    private func nextRadius() -> Distance {
        let options: [Double] = [5, 10, 25, 50]
        guard let index = options.firstIndex(of: presenter.radius.kilometers), index < options.count - 1 else {
            return .km(options[options.count - 1])
        }
        return .km(options[index + 1])
    }
}

#if DEBUG
private struct PreviewSpeciesRepository: SpeciesRepository {
    let species: [Species]
    var error: AppError?

    func getNearbySpecies(
        at location: Location,
        radius: Distance
    ) -> AnyPublisher<[Species], AppError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func searchSpecies(
        query: String
    ) -> AnyPublisher<[Species], AppError> {
        Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func getSpeciesProfile(
        id: Species.ID
    ) -> AnyPublisher<SpeciesProfile, AppError> {
        Just(
            SpeciesProfile(summary: nil, summarySource: nil)
        ).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewWeatherRepository: WeatherRepository {
    let context: WeatherContext

    func context(
        at location: Location
    ) -> AnyPublisher<WeatherContext, AppError> {
        Just(context).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewLocationRepository: LocationRepository {
    func searchLocations(
        query: String
    ) -> AnyPublisher<[Location], AppError> {
        Just([.jakarta]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewFieldGuideRepository: FieldGuideRepository {
    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
    
    func isSaved(
        _ id: Species.ID
    ) -> AnyPublisher<Bool, Never> { Just(false).eraseToAnyPublisher() }
    
    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
    
    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private extension ExplorePresenter {
    static func preview(
        species: [Species],
        weather: WeatherContext,
        error: AppError? = nil
    ) -> ExplorePresenter {
        let fieldGuide = PreviewFieldGuideRepository()
        
        return ExplorePresenter(
            getNearbySpecies: GetNearbySpeciesUseCase(
                repository: PreviewSpeciesRepository(species: species, error: error)
            ),
            getWeatherContext: GetWeatherContextUseCase(
                repository: PreviewWeatherRepository(context: weather)
            ),
            searchLocation: SearchLocationUseCase(repository: PreviewLocationRepository()),
            toggleFavorite: ToggleFavoriteUseCase(repository: fieldGuide),
            observeSavedIDs: ObserveSavedSpeciesIDsUseCase(repository: fieldGuide)
        )
    }
}

private let previewSpecies: [Species] = [
    Species(
        id: 1,
        scientificName: "Copsychus saularis",
        commonName: "Oriental Magpie Robin",
        kingdom: "Animalia",
        phylum: "Chordata",
        className: "Aves",
        order: "Passeriformes",
        family: "Muscicapidae",
        genus: "Copsychus",
        description: nil,
        image: nil,
        localObservationCount: 3,
        lastObservedAt: nil,
        source: nil
    ),
    Species(
        id: 2,
        scientificName: "Acridotheres javanicus",
        commonName: "Javan Myna",
        kingdom: "Animalia",
        phylum: "Chordata",
        className: "Aves",
        order: "Passeriformes",
        family: "Sturnidae",
        genus: "Acridotheres",
        description: nil,
        image: nil,
        localObservationCount: 7,
        lastObservedAt: nil,
        source: nil
    )
]

private let previewWeather = WeatherContext(
    temperatureCelsius: 28,
    relativeHumidity: 74,
    precipitation: 0,
    weatherCode: 1,
    pm25: 18,
    capturedAt: .now
)

#Preview("Loaded") {
    ExploreView(
        presenter: .preview(species: previewSpecies, weather: previewWeather)
    )
}

#Preview("Empty") {
    ExploreView(
        presenter: .preview(species: [], weather: previewWeather)
    )
}

#Preview("Failed") {
    ExploreView(
        presenter: .preview(species: [], weather: previewWeather, error: .networkUnavailable)
    )
}
#endif
