//
//  ReducedMotion.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import UIKit

public enum ReducedMotion {
    public static var isEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }
}
