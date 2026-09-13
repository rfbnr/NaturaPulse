//
//  Haptics.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import UIKit

public enum Haptics {
    public static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    public static func impactLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    public static func favoriteToggle(wasSaved: Bool) {
        if wasSaved {
            impactLight()
        } else {
            success()
        }
    }
}
