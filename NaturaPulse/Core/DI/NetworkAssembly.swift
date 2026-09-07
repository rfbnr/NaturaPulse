//
//  NetworkAssembly.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Swinject

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(APIClient.self) { _ in
            AlamofireAPIClient()
        }
        .inObjectScope(.container)
    }
}
