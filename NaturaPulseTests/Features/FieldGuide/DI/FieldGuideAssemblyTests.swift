//
//  FieldGuideAssemblyTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import Swinject
@testable import NaturaPulse

@MainActor
final class FieldGuideAssemblyTests: XCTestCase {
    func testResolvesFieldGuideRepository() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(FieldGuideRepository.self))
    }

    func testResolvesFieldGuidePresenter() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(FieldGuidePresenter.self))
    }

    func testResolvesToggleFavoriteUseCase() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(ToggleFavoriteUseCase.self))
    }

    func testResolvesObserveIsSavedUseCase() {
        let container = AppContainer()
        XCTAssertNotNil(container.resolver.resolve(ObserveIsSavedUseCase.self))
    }
}
