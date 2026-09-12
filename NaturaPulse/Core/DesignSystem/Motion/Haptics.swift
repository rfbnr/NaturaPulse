//
//  Haptics.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import UIKit

enum Haptics {
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func impactLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func favoriteToggle(wasSaved: Bool) {
        if wasSaved {
            impactLight()
        } else {
            success()
        }
    }
}
