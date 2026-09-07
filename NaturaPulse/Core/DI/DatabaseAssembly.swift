//
//  DatabaseAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class DatabaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(RealmProvider.self) { _ in
            DefaultRealmProvider()
        }
        .inObjectScope(.container)
    }
}
