//
//  SpeciesDetailViewProvider.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 14/09/26.
//

import Common
import SwiftUI

public struct SpeciesDetailViewProvider: SpeciesDetailViewProviding {
    private let factory: SpeciesDetailPresenterFactory

    public init(factory: SpeciesDetailPresenterFactory) {
        self.factory = factory
    }

    @MainActor
    public func makeDetailView(for species: Species) -> AnyView {
        AnyView(SpeciesDetailView(presenter: factory.make(species: species)))
    }
}
