//
//  Extension+Color.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUICore
import UIKit

extension Color {
    static let vlColor = ColorTheme()
}

struct ColorTheme {
    let uiWhite = UIColor.white
    let uiBlack = UIColor.black
    let uiTextPrimary = UIColor(named: "textPrimary") ?? UIColor(red: 74/255, green: 74/255, blue: 89/255, alpha: 1)
    let background = Color("background")
    let buttons = Color("buttons")
    let burgerButton = Color("burgerButton")
    let titlePriceSummary = Color("titlePriceSummary")
    let dashesLine = Color("dashesLine")
}

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
