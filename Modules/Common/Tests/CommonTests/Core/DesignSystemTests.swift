//
//  DesignSystemTests.swift
//  NaturaPulse
//
//  Created by Ridwan Febnur AR on 07/09/26.
//

import SwiftUI
import XCTest
@testable import Common

final class DesignSystemTests: XCTestCase {
    func testSpacingScaleIsMonotonic() {
        XCTAssertLessThan(AppSpacing.xs, AppSpacing.sm)
        XCTAssertLessThan(AppSpacing.sm, AppSpacing.md)
        XCTAssertLessThan(AppSpacing.md, AppSpacing.lg)
        XCTAssertLessThan(AppSpacing.lg, AppSpacing.xl)
    }

    func testStateViewsInstantiate() {
        _ = LoadingStateView()
        _ = EmptyStateView(title: "T", message: "M", actionTitle: nil, action: nil)
        _ = ErrorStateView(message: "err", retry: {})
    }
}
