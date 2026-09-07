//
//  Distance.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

struct Distance: Equatable {
    let kilometers: Double

    static func km(_ value: Double) -> Distance {
        Distance(kilometers: value)
    }
}
