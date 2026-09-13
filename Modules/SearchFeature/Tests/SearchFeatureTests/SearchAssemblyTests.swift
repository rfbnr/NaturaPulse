//
//  SearchAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import SearchFeature
import Common
import CommonTestSupport

@MainActor
final class SearchAssemblyTests: XCTestCase {
    private func makeResolver() -> Resolver {
        Assembler([CommonAssembly(), SearchAssembly()]).resolver
    }

    func testResolvesSearchPresenter() {
        XCTAssertNotNil(makeResolver().resolve(SearchPresenter.self))
    }

    func testResolvesSearchSpeciesUseCase() {
        XCTAssertNotNil(makeResolver().resolve(SearchSpeciesUseCase.self))
    }
}
