//
//  Extension+UINavigationBar.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 20.08.2025.
//

import UIKit
import SwiftUICore

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
