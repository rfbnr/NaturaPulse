//
//  SpeciesDetailAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import SpeciesDetailFeature
import Common
import CommonTestSupport

@MainActor
final class SpeciesDetailAssemblyTests: XCTestCase {
    func testResolvesFactoryAndBuildsPresenter() {
        let assembler = Assembler([CommonAssembly(), SpeciesDetailAssembly()])
        let factory = assembler.resolver.resolve(SpeciesDetailPresenterFactory.self)
        XCTAssertNotNil(factory)
        let presenter = factory?.make(species: Species.stub(id: 1))
        XCTAssertNotNil(presenter)
    }
}
