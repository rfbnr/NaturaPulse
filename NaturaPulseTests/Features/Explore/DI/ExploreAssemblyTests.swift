//
//  ExploreAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import NaturaPulse

@MainActor
final class ExploreAssemblyTests: XCTestCase {
    func testResolvesExplorePresenter() {
        let container = AppContainer()
        let presenter = container.resolver.resolve(ExplorePresenter.self)
        XCTAssertNotNil(presenter)
    }

    func testResolvesSpeciesRepository() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(SpeciesRepository.self))
    }
}
