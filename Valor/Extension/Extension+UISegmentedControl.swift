//
//  Extension+UISegmentedControl.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//


import UIKit
import SwiftUI

/// Applies a custom style to all UISegmentedControl instances using the appearance proxy.
/// Sets the selected segment tint color to white and customizes title text attributes
/// for both selected and normal states with specific colors and fonts.
extension UISegmentedControl {
    static func applyCustomStyle() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .foregroundColor: Color.vlColor.uiBlack,
                .font: Font.titleSFProRegular
            ],
            for: .selected
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [
                .foregroundColor: Color.vlColor.uiTextPrimary,
                .font: Font.titleSFProRegular
            ],
            for: .normal
        )
    }
}
