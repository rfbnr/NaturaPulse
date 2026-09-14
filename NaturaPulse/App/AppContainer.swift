//
//  AppContainer.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Common
import ExploreFeature
import FieldGuideFeature
import SearchFeature
import SpeciesDetailFeature
import Swinject

final class AppContainer {
    private let assembler: Assembler

    var resolver: Resolver {
        assembler.resolver
    }

    init() {
        assembler = Assembler([
            CommonAssembly(),
            AppAssembly(),
            ExploreAssembly(),
            SearchAssembly(),
            SpeciesDetailAssembly(),
            FieldGuideAssembly()
        ])
    }
}
