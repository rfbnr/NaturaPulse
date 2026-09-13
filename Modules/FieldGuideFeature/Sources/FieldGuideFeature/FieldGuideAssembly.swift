//
//  FieldGuideAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import Swinject

public final class FieldGuideAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(FieldGuidePresenter.self) { resolver in
            MainActor.assumeIsolated {
                FieldGuidePresenter(
                    getSavedSpecies: resolver.resolveRequired(GetSavedSpeciesUseCase.self),
                    removeSavedSpecies: resolver.resolveRequired(RemoveSavedSpeciesUseCase.self)
                )
            }
        }
        .inObjectScope(.transient)
    }
}
