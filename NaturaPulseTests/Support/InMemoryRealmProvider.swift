//
//  InMemoryRealmProvider.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation
import RealmSwift
@testable import NaturaPulse

final class InMemoryRealmProvider: RealmProvider {
    private let backing: Realm

    init() throws {
        let configuration = Realm.Configuration(inMemoryIdentifier: "test-\(UUID().uuidString)")
        backing = try Realm(configuration: configuration)
    }

    func realm() throws -> Realm {
        backing
    }
}
