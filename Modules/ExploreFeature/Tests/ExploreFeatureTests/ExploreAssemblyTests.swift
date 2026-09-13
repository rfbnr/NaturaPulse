//
//  ExploreAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import ExploreFeature
import Common
import CommonTestSupport

@MainActor
final class ExploreAssemblyTests: XCTestCase {
    private func makeResolver() -> Resolver {
        Assembler([CommonAssembly(), ExploreAssembly()]).resolver
    }

    func testResolvesExplorePresenter() {
        let presenter = makeResolver().resolve(ExplorePresenter.self)
        XCTAssertNotNil(presenter)
    }

    func testResolvesSpeciesRepository() {
        XCTAssertNotNil(makeResolver().resolve(SpeciesRepository.self))
    }
}
