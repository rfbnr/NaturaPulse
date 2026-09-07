//
//  AppRoute.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

/// Navigation destinations reachable from within the app shell.
enum AppRoute: Hashable {
    case speciesDetail(id: Int)
    case locationSearch
}
