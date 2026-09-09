//
//  Haptics.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 10/09/26.
//

import UIKit

/// Thin wrapper over UIKit feedback generators. Called from the View layer
/// only — never from presenters, use cases, or repositories — so UIKit does
/// not leak below the presentation boundary. Best-effort and silent on the
/// simulator; must never gate or delay the action that triggers it.
enum Haptics {
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func impactLight() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    /// Feedback for a favorite toggle, chosen from the state BEFORE the
    /// toggle: already saved → about to remove → light impact; not saved →
    /// about to save → success notification.
    static func favoriteToggle(wasSaved: Bool) {
        if wasSaved {
            impactLight()
        } else {
            success()
        }
    }
}
