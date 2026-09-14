//
//  SpeciesDetailViewProviding.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 14/09/26.
//

import SwiftUI

public protocol SpeciesDetailViewProviding {
    @MainActor func makeDetailView(for species: Species) -> AnyView
}
