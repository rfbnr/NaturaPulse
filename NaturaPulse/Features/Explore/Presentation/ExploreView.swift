//
//  ExploreView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import SwiftUI

/// The Explore tab: a greeting, the current location and search radius,
/// ambient environmental context, and a list of nearby species.
struct ExploreView: View {
    @State var presenter: ExplorePresenter
    @State private var isLocationPickerPresented = false

    private var greeting: String {
        switch Calendar.current.component(.hour, from: .now) {
        case 5..<12: "Good morning"
        case 12..<17: "Good afternoon"
        case 17..<22: "Good evening"
        default: "Good night"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.lg) {
                    header

                    if case .loaded(let weather) = presenter.weatherState {
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

                Spacer()

                if case .loaded(let species) = presenter.speciesState {
                    Text("\(species.count)")
                        .font(AppTypography.caption())
                        .foregroundStyle(AppColor.secondaryText)
                        .accessibilityLabel("\(species.count) species found")
                }
            }

            speciesContent
        }
    }

    @ViewBuilder
    private var speciesContent: some View {
        switch presenter.speciesState {
        case .idle, .loading:
            LoadingStateView()
        case .loaded(let species):
            VStack(spacing: AppSpacing.md) {
                ForEach(species) { item in
                    SpeciesCardView(species: item)
                }
            }
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

    private func nextRadius() -> Distance {
        let options: [Double] = [5, 10, 25, 50]
        guard let index = options.firstIndex(of: presenter.radius.kilometers), index < options.count - 1 else {
            return .km(options[options.count - 1])
        }
        return .km(options[index + 1])
    }
}

/// A human-readable, non-technical message for surfacing an `AppError`
/// in the UI (e.g. `ErrorStateView`).
extension AppError {
    var userMessage: String {
        switch self {
        case .networkUnavailable:
            "You're offline. Check your connection and try again."
        case .server:
            "Something went wrong on our end. Please try again."
        case .decoding:
            "We had trouble reading that response. Please try again."
        case .notFound:
            "We couldn't find what you were looking for."
        case .persistence:
            "We couldn't save your data. Please try again."
        case .locationDenied:
            "Location access is turned off. You can still search for a place."
        case .permissionRestricted:
            "This feature isn't available due to device restrictions."
        case .unknown:
            "Something went wrong. Please try again."
        }
    }
}

#if DEBUG
/// In-memory fakes used only to drive Xcode previews. Not shipped
/// production code and never wired into the app's dependency graph.
private struct PreviewSpeciesRepository: SpeciesRepository {
    let species: [Species]
    var error: AppError?

    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func getSpeciesDetail(id: Species.ID) -> AnyPublisher<Species, AppError> {
        guard let match = species.first(where: { $0.id == id }) else {
            return Fail(error: .notFound).eraseToAnyPublisher()
        }
        return Just(match).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewWeatherRepository: WeatherRepository {
    let context: WeatherContext

    func context(at location: Location) -> AnyPublisher<WeatherContext, AppError> {
        Just(context).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewLocationRepository: LocationRepository {
    func searchLocations(query: String) -> AnyPublisher<[Location], AppError> {
        Just([.jakarta]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private extension ExplorePresenter {
    static func preview(species: [Species], weather: WeatherContext, error: AppError? = nil) -> ExplorePresenter {
        ExplorePresenter(
            getNearbySpecies: GetNearbySpeciesUseCase(
                repository: PreviewSpeciesRepository(species: species, error: error)
            ),
            getWeatherContext: GetWeatherContextUseCase(repository: PreviewWeatherRepository(context: weather)),
            searchLocation: SearchLocationUseCase(repository: PreviewLocationRepository())
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
    ExploreView(presenter: .preview(species: previewSpecies, weather: previewWeather))
}

#Preview("Empty") {
    ExploreView(presenter: .preview(species: [], weather: previewWeather))
}

#Preview("Failed") {
    ExploreView(presenter: .preview(species: [], weather: previewWeather, error: .networkUnavailable))
}
#endif
