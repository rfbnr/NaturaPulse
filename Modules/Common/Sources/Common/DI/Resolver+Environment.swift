//
//  Resolver+Environment.swift
//  Common
//
//  Created by Ridwan Febnur AR on 13/09/26.
//

import SwiftUI
import Swinject

private struct ResolverKey: EnvironmentKey {
    static let defaultValue: Resolver = Container()
}

public extension EnvironmentValues {
    var resolver: Resolver {
        get { self[ResolverKey.self] }
        set { self[ResolverKey.self] = newValue }
    }
}

public extension Resolver {
    func resolveRequired<Service>(_ serviceType: Service.Type) -> Service {
        guard let resolved = resolve(serviceType) else {
            preconditionFailure("Failed to resolve \(Service.self). Check DI registration.")
        }
        return resolved
    }
}
