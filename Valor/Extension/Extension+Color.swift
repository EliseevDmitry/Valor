//
//  Extension+Color.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUICore
import UIKit

/// Extension to provide a centralized color theme for the application.
/// Adds `vlColor` to `Color` for convenient access to app-specific colors.
extension Color {
    static let vlColor = ColorTheme()
}

/// Represents the main color palette used throughout the app.
/// ColorTheme provides both UIColor (for UIKit components) and Color (for SwiftUI) representations,
/// since the project includes a mix of UIKit and SwiftUI components.
/// To avoid duplicating colors in both formats, ColorTheme includes an extension with computed properties
/// that automatically convert UIColor instances to SwiftUI Color instances.
struct ColorTheme {
    let uiWhite = UIColor.white
    let uiBlack = UIColor.black
    let uiTextPrimary = UIColor(named: "textPrimary") ?? UIColor(
        red: 74/255,
        green: 74/255,
        blue: 89/255,
        alpha: 1
    )
    let background = Color("background")
    let buttons = Color("buttons")
    let burgerButton = Color("burgerButton")
    let titlePriceSummary = Color("titlePriceSummary")
    let dashesLine = Color("dashesLine")
}

/// SwiftUI-compatible computed colors derived from the main UIColor palette for seamless use in SwiftUI views.
extension ColorTheme {
    var text: Color {
        Color(uiBlack)
    }
    
    var vlBackground: Color {
        Color(uiWhite)
    }
    
    var textPrimary: Color {
        Color(uiTextPrimary)
    }
}
