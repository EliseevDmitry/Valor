//
//  Untitled.swift
//  StairsGallery
//
//  Created by Dmitriy Eliseev on 20.04.2025.
//

import SwiftUI

private struct ScreenWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0.0
}

extension EnvironmentValues {
    var screenWidth: CGFloat {
        get { self[ScreenWidthKey.self] }
        set { self[ScreenWidthKey.self] = newValue }
    }
}
