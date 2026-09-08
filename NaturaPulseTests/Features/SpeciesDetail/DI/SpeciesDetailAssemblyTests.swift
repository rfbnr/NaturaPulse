//
//  SpeciesDetailAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import NaturaPulse

@MainActor
final class SpeciesDetailAssemblyTests: XCTestCase {
    func testResolvesFactoryAndBuildsPresenter() {
        let container = AppContainer()
        let factory = container.resolver.resolve(SpeciesDetailPresenterFactory.self)
        XCTAssertNotNil(factory)
        let presenter = factory?.make(species: Species.stub(id: 1))
        XCTAssertNotNil(presenter)
    }
}
