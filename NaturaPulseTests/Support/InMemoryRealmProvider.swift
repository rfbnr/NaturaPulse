//
//  InMemoryRealmProvider.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation
import RealmSwift
@testable import NaturaPulse

/// A RealmProvider backed by a per-instance in-memory Realm. Holds one strong
/// Realm reference so the in-memory store survives across calls, and returns it
/// (all test access is on the main thread).
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
