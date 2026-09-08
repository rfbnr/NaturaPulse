//
//  SearchAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import NaturaPulse

@MainActor
final class SearchAssemblyTests: XCTestCase {
    func testResolvesSearchPresenter() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(SearchPresenter.self))
    }

    func testResolvesSearchSpeciesUseCase() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(SearchSpeciesUseCase.self))
    }
}
