//
//  Distance.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import Foundation

public struct Distance: Equatable {
    public let kilometers: Double

    public static func km(_ value: Double) -> Distance {
        Distance(kilometers: value)
    }
}
