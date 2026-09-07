//
//  NaturaPulseApp.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI

@main
struct NaturaPulseApp: App {
    private let container = AppContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(\.resolver, container.resolver)
        }
    }
}
