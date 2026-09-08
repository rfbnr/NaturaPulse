//
//  SearchView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import SwiftUI

/// The Search tab: a search field over species by name, with results
/// navigating to a (placeholder) detail screen.
struct SearchView: View {
    @State var presenter: SearchPresenter

    var body: some View {
        NavigationStack(path: $presenter.path) {
            content
                .background(AppColor.background)
                .navigationTitle("Search")
                .searchable(text: $presenter.query, prompt: "Search species by name")
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle:
            EmptyStateView(
                title: "Search species",
                message: "Type a name to find species",
                actionTitle: nil,
                action: nil
            )
        case .loading(let previous):
            if let previous {
                resultsList(previous)
                    .opacity(0.6)
            } else {
                LoadingStateView()
            }
        case .loaded(let species):
            resultsList(species)
        case .empty:
            EmptyStateView(
                title: "No matches",
                message: "Try a different name",
                actionTitle: nil,
                action: nil
            )
        case .failed(let error):
            ErrorStateView(message: error.userMessage, retry: presenter.retry)
        }
    }

    private func resultsList(_ species: [Species]) -> some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                ForEach(species) { item in
                    Button {
                        presenter.select(species: item)
                    } label: {
                        SpeciesCardView(species: item)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(item.commonName ?? item.scientificName)
                }
            }
            .padding(AppSpacing.md)
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .speciesDetail(let id):
            if let species = speciesInResults(id: id) {
                SpeciesDetailPlaceholderView(species: species)
            } else {
                SpeciesDetailFallbackView(id: id)
            }
        case .locationSearch:
            EmptyView()
        }
    }

    /// Resolves the tapped species from the currently loaded results, since
    /// the route only carries the species id. A future increment (M4) will
    /// fetch the species by id instead of relying on this lookup.
    private func speciesInResults(id: Species.ID) -> Species? {
        guard case .loaded(let list) = presenter.state else { return nil }
        return list.first(where: { $0.id == id })
    }
}

/// Minimal fallback shown when a species can't be resolved from the current
/// results (e.g. the results changed while navigating).
private struct SpeciesDetailFallbackView: View {
    let id: Species.ID

    var body: some View {
        EmptyStateView(
            title: "Species #\(id)",
            message: "Full species details arrive in a later update.",
            actionTitle: nil,
            action: nil
        )
        .background(AppColor.background)
        .navigationTitle("Species #\(id)")
    }
}

#if DEBUG
/// In-memory fake used only to drive Xcode previews. Not shipped production
/// code and never wired into the app's dependency graph.
private struct PreviewSpeciesRepository: SpeciesRepository {
    let species: [Species]
    var error: AppError?

    func getNearbySpecies(at location: Location, radius: Distance) -> AnyPublisher<[Species], AppError> {
        Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func searchSpecies(query: String) -> AnyPublisher<[Species], AppError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func getSpeciesDetail(id: Species.ID) -> AnyPublisher<Species, AppError> {
        guard let match = species.first(where: { $0.id == id }) else {
            return Fail(error: .notFound).eraseToAnyPublisher()
        }
        return Just(match).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private extension SearchPresenter {
    /// Builds a presenter for previews. Passing `query` seeds `query` after
    /// construction so the debounced search pipeline runs and the preview
    /// settles into `.loaded`/`.empty`/`.failed` shortly after appearing;
    /// omit it to preview the initial `.idle` state.
    static func preview(query: String = "", species: [Species], error: AppError? = nil) -> SearchPresenter {
        let presenter = SearchPresenter(
            searchSpecies: SearchSpeciesUseCase(repository: PreviewSpeciesRepository(species: species, error: error))
        )
        if !query.isEmpty {
            presenter.query = query
        }
        return presenter
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

#Preview("Idle") {
    SearchView(presenter: .preview(species: []))
}

#Preview("Loaded") {
    SearchView(presenter: .preview(query: "myna", species: previewSpecies))
}

#Preview("Empty") {
    SearchView(presenter: .preview(query: "zzz", species: []))
}

#Preview("Failed") {
    SearchView(presenter: .preview(query: "myna", species: [], error: .networkUnavailable))
}
#endif
