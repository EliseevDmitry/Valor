//
//  LocalizeRouting.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 28.08.2025.
//

import SwiftUI

/// Provides localized strings for UI elements related to routing/navigation.
/// `title` returns the localized string used as the navigation bar title for routing views.
enum LocalizeRouting {
    static var title: String {
        NSLocalizedString(
            "routing.title",
            comment: "Title displayed in the navigation bar of routing-related screens"
        )
    }
}
