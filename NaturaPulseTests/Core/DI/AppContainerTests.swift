//
//  AppContainerTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject
import XCTest
@testable import NaturaPulse

final class AppContainerTests: XCTestCase {

    func testResolvesAPIClient() {
        let container = AppContainer()
        let client = container.resolver.resolve(APIClient.self)
        XCTAssertNotNil(client)
    }

    func testResolvesRealmProvider() {
        let container = AppContainer()
        let provider = container.resolver.resolve(RealmProvider.self)
        XCTAssertNotNil(provider)
    }

    func testAPIClientIsContainerScopedSingleton() {
        let container = AppContainer()
        let first = container.resolver.resolve(APIClient.self)
        let second = container.resolver.resolve(APIClient.self)
        XCTAssertTrue((first as AnyObject) === (second as AnyObject))
    }
}
