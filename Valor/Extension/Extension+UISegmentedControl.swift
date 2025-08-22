//
//  Extension+UISegmentedControl.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//


import UIKit
import SwiftUI

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
