//
//  Extension+UINavigationBar.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 20.08.2025.
//

import UIKit
import SwiftUICore

/// Extension to UINavigationBar providing a centralized method to apply the app’s custom visual style.
/// Configures background color, shadow, and title text attributes for a consistent appearance across all navigation bars.
extension UINavigationBar {
    static func applyValorStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.shadowColor = Color.vlColor.uiWhite
        appearance.backgroundColor = Color.vlColor.uiWhite
        appearance.titleTextAttributes = [
            .foregroundColor: Color.vlColor.uiBlack,
            .font: Font.aBeeZeeRegular
        ]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
