//
//  ReducedMotion.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import UIKit

enum ReducedMotion {
    static var isEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
}
