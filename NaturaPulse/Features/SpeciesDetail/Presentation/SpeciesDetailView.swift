//
//  SpeciesDetailView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import SwiftUI

/// The full species detail screen: hero image, local sighting stats,
/// taxonomy, ambient environmental context (neutral background
/// information — never a causal claim, PRD §10.3), and an on-demand
/// species description sourced from GBIF.
struct SpeciesDetailView: View {
    @State var presenter: SpeciesDetailPresenter

    private var displayName: String {
        presenter.species.commonName ?? presenter.species.scientificName
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                SpeciesImageView(url: presenter.species.image?.url)
                    .clipShape(RoundedRectangle(cornerRadius: AppSpacing.md))
                    .accessibilityLabel("\(displayName) photo")

                header
                sightingsSection
                taxonomySection
                environmentSection
                aboutSection
                attributionSection
            }
            .padding(AppSpacing.md)
        }
        .background(AppColor.background)
        .navigationTitle(displayName)
        .onAppear { presenter.onAppear() }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    presenter.toggleFavorite()
                } label: {
                    Image(systemName: presenter.isSaved ? "heart.fill" : "heart")
                }
                .tint(presenter.isSaved ? AppColor.accent : nil)
                .accessibilityLabel(presenter.isSaved ? "Remove from Field Guide" : "Add to Field Guide")
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(displayName)
                .font(AppTypography.title())
                .foregroundStyle(AppColor.primaryText)

            if presenter.species.commonName != nil {
                Text(presenter.species.scientificName)
                    .font(AppTypography.body())
                    .italic()
                    .foregroundStyle(AppColor.secondaryText)
            }
        }
    }

    // MARK: - Local sightings

    private var recordsLabel: String {
        let count = presenter.species.localObservationCount
        return count == 1 ? "1 local record" : "\(count) local records"
    }

    private var sightingsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(recordsLabel)
                .font(AppTypography.headline())
                .foregroundStyle(AppColor.primaryText)
                .accessibilityLabel(recordsLabel)

            if let lastObservedAt = presenter.species.lastObservedAt {
                let formatted = lastObservedAt.formatted(date: .abbreviated, time: .omitted)
                Text("Last recorded \(formatted)")
                    .font(AppTypography.caption())
                    .foregroundStyle(AppColor.secondaryText)
                    .accessibilityLabel("Last recorded \(formatted)")
            }
        }
    }

    // MARK: - Taxonomy

    private var taxonomyRows: [(label: String, value: String)] {
        let species = presenter.species
        return [
            species.family.map { (label: "Family", value: $0) },
            species.genus.map { (label: "Genus", value: $0) },
            species.order.map { (label: "Order", value: $0) },
            species.className.map { (label: "Class", value: $0) }
        ].compactMap { $0 }
    }

    @ViewBuilder
    private var taxonomySection: some View {
        if !taxonomyRows.isEmpty {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Taxonomy")
                    .font(AppTypography.headline())
                    .foregroundStyle(AppColor.primaryText)

                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    ForEach(taxonomyRows, id: \.label) { row in
                        HStack {
                            Text(row.label)
                                .font(AppTypography.body())
                                .foregroundStyle(AppColor.secondaryText)
                            Spacer()
                            Text(row.value)
                                .font(AppTypography.body())
                                .foregroundStyle(AppColor.primaryText)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(row.label): \(row.value)")
                    }
                }
                .padding(AppSpacing.md)
                .background(AppColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppSpacing.md))
            }
        }
    }

    // MARK: - Environmental context

    @ViewBuilder
    private var environmentSection: some View {
        switch presenter.weatherState {
        case .idle, .empty, .failed:
            EmptyView()
        case .loading:
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Environmental context")
                    .font(AppTypography.headline())
                    .foregroundStyle(AppColor.primaryText)
                ProgressView()
                    .controlSize(.small)
                    .accessibilityLabel("Loading environmental context")
            }
        case .loaded(let context):
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text("Environmental context")
                    .font(AppTypography.headline())
                    .foregroundStyle(AppColor.primaryText)
                WeatherContextCardView(weather: context)
            }
        }
    }

    // MARK: - About this species

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("About this species")
                .font(AppTypography.headline())
                .foregroundStyle(AppColor.primaryText)

            aboutContent
        }
    }

    @ViewBuilder
    private var aboutContent: some View {
        switch presenter.profileState {
        case .idle, .loading:
            HStack(spacing: AppSpacing.sm) {
                ProgressView()
                    .controlSize(.small)
                Text("Loading description…")
                    .font(AppTypography.body())
                    .foregroundStyle(AppColor.secondaryText)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Loading description")
        case .loaded(let profile):
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                if let summary = profile.summary {
                    Text(summary)
                        .font(AppTypography.body())
                        .foregroundStyle(AppColor.primaryText)
                }
                if let summarySource = profile.summarySource {
                    Text("Source: \(summarySource)")
                        .font(AppTypography.caption())
                        .foregroundStyle(AppColor.secondaryText)
                }
            }
        case .empty:
            Text("No description available.")
                .font(AppTypography.body())
                .foregroundStyle(AppColor.secondaryText)
        case .failed(let error):
            ErrorStateView(message: error.userMessage, retry: presenter.retry)
        }
    }

    // MARK: - Source & attribution

    private var attributionSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text("Source & attribution")
                .font(AppTypography.headline())
                .foregroundStyle(AppColor.primaryText)

            if let image = presenter.species.image {
                if let creator = image.creator {
                    Text("Photo by \(creator)")
                        .font(AppTypography.caption())
                        .foregroundStyle(AppColor.secondaryText)
                }
                if let license = image.license {
                    Text(license)
                        .font(AppTypography.caption())
                        .foregroundStyle(AppColor.secondaryText)
                }
            }

            Text("Data: GBIF · Open-Meteo")
                .font(AppTypography.caption())
                .foregroundStyle(AppColor.secondaryText)
        }
    }
}

#if DEBUG
/// In-memory fakes used only to drive Xcode previews. Not shipped
/// production code and never wired into the app's dependency graph.
private struct PreviewSpeciesRepository: SpeciesRepository {
    let profile: SpeciesProfile
    var profileError: AppError?

    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func getSpeciesProfile(id: Species.ID) -> AnyPublisher<SpeciesProfile, AppError> {
        if let profileError {
            return Fail(error: profileError).eraseToAnyPublisher()
        }
        return Just(profile).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewWeatherRepository: WeatherRepository {
    let weather: WeatherContext

    func context(at location: Location) -> AnyPublisher<WeatherContext, AppError> {
        Just(weather).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private struct PreviewFieldGuideRepository: FieldGuideRepository {
    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        Just([]).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never> {
        Just(false).eraseToAnyPublisher()
    }

    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private extension SpeciesDetailPresenter {
    static func preview(
        species: Species,
        profile: SpeciesProfile,
        weather: WeatherContext,
        profileError: AppError? = nil
    ) -> SpeciesDetailPresenter {
        let fieldGuideRepository = PreviewFieldGuideRepository()
        return SpeciesDetailPresenter(
            species: species,
            getSpeciesProfile: GetSpeciesProfileUseCase(
                repository: PreviewSpeciesRepository(profile: profile, profileError: profileError)
            ),
            getWeatherContext: GetWeatherContextUseCase(repository: PreviewWeatherRepository(weather: weather)),
            toggleFavorite: ToggleFavoriteUseCase(repository: fieldGuideRepository),
            observeIsSaved: ObserveIsSavedUseCase(repository: fieldGuideRepository)
        )
    }
}

private let previewImage = SpeciesImage(
    url: URL(string: "https://images.example.com/oriental-magpie-robin.jpg") ?? URL(filePath: "/"),
    creator: "Jane Birder",
    license: "CC BY 4.0",
    sourceURL: nil
)

private let previewSpecies = Species(
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
    image: previewImage,
    localObservationCount: 3,
    lastObservedAt: .now,
    source: nil,
    coordinate: Coordinate(latitude: -6.2, longitude: 106.8)
)

private let previewProfile = SpeciesProfile(
    summary: "A common resident bird known for its melodious song and striking black-and-white plumage.",
    summarySource: "GBIF"
)

private let previewWeather = WeatherContext(
    temperatureCelsius: 28,
    relativeHumidity: 74,
    precipitation: 0,
    weatherCode: 1,
    pm25: 18,
    capturedAt: .now
)

#Preview("Loaded") {
    NavigationStack {
        SpeciesDetailView(
            presenter: .preview(species: previewSpecies, profile: previewProfile, weather: previewWeather)
        )
    }
}

#Preview("Description failed") {
    NavigationStack {
        SpeciesDetailView(
            presenter: .preview(
                species: previewSpecies,
                profile: previewProfile,
                weather: previewWeather,
                profileError: .networkUnavailable
            )
        )
    }
}
#endif
