//
//  Extension+EnvironmentValues.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 20.04.2025.
//

import SwiftUI

/// Custom environment key for accessing the device's screen width in SwiftUI.
/// Allows reading or overriding the width via `EnvironmentValues.screenWidth`.
/// Useful for determining the screen width once (e.g., at launch with `GeometryReader`)
/// and reusing it throughout the app for consistent layout.
private struct ScreenWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0.0
}

extension EnvironmentValues {
    var screenWidth: CGFloat {
        get { self[ScreenWidthKey.self] }
        set { self[ScreenWidthKey.self] = newValue }
    }
}
