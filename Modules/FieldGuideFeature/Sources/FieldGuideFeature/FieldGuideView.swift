//
//  FieldGuideView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import Common
import SpeciesDetailFeature
import Swinject
import SwiftUI

public struct FieldGuideView: View {
    @State var presenter: FieldGuidePresenter
    @Environment(\.resolver) private var resolver

    public init(presenter: FieldGuidePresenter) {
        _presenter = State(initialValue: presenter)
    }

    public var body: some View {
        NavigationStack(path: $presenter.path) {
            content
                .background(AppColor.background)
                .navigationTitle("Field Guide")
                .onAppear { presenter.onAppear() }
                .navigationDestination(for: AppRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle, .loading:
            LoadingStateView()
        case .loaded(let species):
            speciesList(species)
        case .empty:
            EmptyStateView(
                title: "Your Field Guide is empty",
                message: "Save species you discover and they'll appear here.",
                actionTitle: nil,
                action: nil
            )
        case .failed(let error):
            ErrorStateView(message: error.userMessage, retry: presenter.retry)
        }
    }

    private func speciesList(_ species: [Species]) -> some View {
        List {
            ForEach(species) { item in
                Button {
                    presenter.select(species: item)
                } label: {
                    SpeciesCardView(
                        species: item,
                        isSaved: true,
                        onToggleFavorite: {
                            presenter.remove(id: item.id)
                            Haptics.impactLight()
                        }
                    )
                }
                .buttonStyle(PressableCardStyle())
                .accessibilityLabel(item.commonName ?? item.scientificName)
                .accessibilityAction(named: "Remove from Field Guide") {
                    presenter.remove(id: item.id)
                    Haptics.impactLight()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(AppColor.background)
                .swipeActions {
                    Button(role: .destructive) {
                        presenter.remove(id: item.id)
                        Haptics.impactLight()
                    } label: {
                        Label("Remove", systemImage: "trash")
                    }
                    .accessibilityLabel("Remove \(item.commonName ?? item.scientificName)")
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .speciesDetail(let species):
            let factory = resolver.resolveRequired(SpeciesDetailPresenterFactory.self)
            SpeciesDetailView(presenter: factory.make(species: species))
        case .locationSearch:
            EmptyView()
        }
    }
}


#if DEBUG
private struct PreviewFieldGuideRepository: FieldGuideRepository {
    let species: [Species]
    var error: AppError?

    func savedSpecies() -> AnyPublisher<[Species], AppError> {
        if let error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return Just(species).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func isSaved(_ id: Species.ID) -> AnyPublisher<Bool, Never> {
        Just(species.contains { $0.id == id }).eraseToAnyPublisher()
    }

    func save(_ species: Species) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }

    func remove(id: Species.ID) -> AnyPublisher<Void, AppError> {
        Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher()
    }
}

private extension FieldGuidePresenter {
    static func preview(
        species: [Species],
        error: AppError? = nil
    ) -> FieldGuidePresenter {
        let repository = PreviewFieldGuideRepository(species: species, error: error)
        
        return FieldGuidePresenter(
            getSavedSpecies: GetSavedSpeciesUseCase(repository: repository),
            removeSavedSpecies: RemoveSavedSpeciesUseCase(repository: repository)
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

#Preview("Loaded") {
    FieldGuideView(
        presenter: .preview(species: previewSpecies)
    )
}

#Preview("Empty") {
    FieldGuideView(
        presenter: .preview(species: [])
    )
}

#Preview("Failed") {
    FieldGuideView(
        presenter: .preview(species: [], error: .persistence)
    )
}
#endif
