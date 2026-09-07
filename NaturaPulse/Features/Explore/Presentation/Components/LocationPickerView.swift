//
//  LocationPickerView.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Combine
import SwiftUI

/// A sheet that lets the user search for a place and select it as the
/// active Explore location. Search is debounced by 300ms so results are
/// not requested on every keystroke, and picking a result immediately
/// updates the presenter and dismisses the sheet.
struct LocationPickerView: View {
    let presenter: ExplorePresenter

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    @State private var results: [Location] = []
    @State private var isSearching = false
    @State private var searchError: AppError?

    private static let debounceNanoseconds: UInt64 = 300_000_000
    private static let minimumQueryLength = 2

    var body: some View {
        NavigationStack {
            List {
                content
            }
            .listStyle(.plain)
            .searchable(text: $query, prompt: "Search for a city or place")
            .navigationTitle("Change Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .task(id: query) {
                await search(for: query)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        if let searchError {
            ErrorStateView(message: searchError.userMessage) {
                Task { await search(for: query) }
            }
            .listRowSeparator(.hidden)
        } else if isSearching {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .listRowSeparator(.hidden)
        } else if results.isEmpty {
            if query.trimmingCharacters(in: .whitespacesAndNewlines).count >= Self.minimumQueryLength {
                Text("No matching places found")
                    .font(AppTypography.body())
                    .foregroundStyle(AppColor.secondaryText)
                    .listRowSeparator(.hidden)
            }
        } else {
            ForEach(Array(results.enumerated()), id: \.offset) { _, location in
                Button {
                    presenter.select(location: location)
                    dismiss()
                } label: {
                    resultRow(for: location)
                }
                .accessibilityLabel(accessibilityLabel(for: location))
            }
        }
    }

    private func resultRow(for location: Location) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(location.name)
                .font(AppTypography.body())
                .foregroundStyle(AppColor.primaryText)
            if let subtitle = subtitle(for: location) {
                Text(subtitle)
                    .font(AppTypography.caption())
                    .foregroundStyle(AppColor.secondaryText)
            }
        }
    }

    private func subtitle(for location: Location) -> String? {
        let parts = [location.administrativeArea, location.country].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: ", ")
    }

    private func accessibilityLabel(for location: Location) -> String {
        [location.name, subtitle(for: location)].compactMap { $0 }.joined(separator: ", ")
    }

    private func search(for query: String) async {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= Self.minimumQueryLength else {
            results = []
            searchError = nil
            isSearching = false
            return
        }

        do {
            try await Task.sleep(nanoseconds: Self.debounceNanoseconds)
        } catch {
            return
        }
        guard !Task.isCancelled else { return }

        isSearching = true
        searchError = nil

        do {
            for try await locations in presenter.searchLocations(trimmed).values {
                guard !Task.isCancelled else { return }
                results = locations
                break
            }
        } catch let error as AppError {
            if !Task.isCancelled {
                searchError = error
                results = []
            }
        } catch {
            // Cancellation or unexpected error types are ignored; a new
            // search will be kicked off by the next query change.
        }

        if !Task.isCancelled {
            isSearching = false
        }
    }
}
