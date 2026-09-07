//
//  RealmProviderTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import XCTest
import RealmSwift
@testable import NaturaPulse

final class RealmProviderTests: XCTestCase {

    func testProvidesRealmInstanceForInMemoryConfiguration() throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: "test-\(UUID().uuidString)")
        let provider = DefaultRealmProvider(configuration: configuration)

        let realm = try provider.realm()

        XCTAssertNotNil(realm)
        XCTAssertTrue(realm.configuration.inMemoryIdentifier != nil)
    }
}
