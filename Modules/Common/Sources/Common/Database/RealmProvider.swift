//
//  RealmProvider.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation
import RealmSwift

protocol RealmProvider {
    func realm() throws -> Realm
}

final class DefaultRealmProvider: RealmProvider {
    private let configuration: Realm.Configuration

    init(configuration: Realm.Configuration = .defaultConfiguration) {
        self.configuration = configuration
    }

    func realm() throws -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            throw DatabaseError.underlying(error.localizedDescription)
        }
    }
}
