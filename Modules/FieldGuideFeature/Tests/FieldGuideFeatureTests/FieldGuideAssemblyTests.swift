//
//  FieldGuideAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import FieldGuideFeature
import Common
import CommonTestSupport

@MainActor
final class FieldGuideAssemblyTests: XCTestCase {
    private func makeResolver() -> Resolver {
        Assembler([CommonAssembly(), FieldGuideAssembly()]).resolver
    }

    func testResolvesFieldGuideRepository() {
        XCTAssertNotNil(makeResolver().resolve(FieldGuideRepository.self))
    }

    func testResolvesFieldGuidePresenter() {
        XCTAssertNotNil(makeResolver().resolve(FieldGuidePresenter.self))
    }

    func testResolvesToggleFavoriteUseCase() {
        XCTAssertNotNil(makeResolver().resolve(ToggleFavoriteUseCase.self))
    }

    func testResolvesObserveIsSavedUseCase() {
        XCTAssertNotNil(makeResolver().resolve(ObserveIsSavedUseCase.self))
    }

    func testResolvesObserveSavedSpeciesIDsUseCase() {
        XCTAssertNotNil(makeResolver().resolve(ObserveSavedSpeciesIDsUseCase.self))
    }
}
