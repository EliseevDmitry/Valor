//
//  LocalizePrices.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 28.08.2025.
//

import SwiftUI

/// Provides localized strings for price-related messages and UI elements.
/// Covers error messages, empty results, retry prompts, and update actions.
/// Facilitates consistent localization of pricing feedback across the app.
enum LocalizePrices {
    static var notFound: String {
        NSLocalizedString(
            "prices.notFound",
            comment: "Message displayed when no results are found"
        )
    }
    
    static var fail: String {
        NSLocalizedString(
            "prices.fail",
            comment: "Error message shown when something goes wrong"
        )
    }
    
    static var tryLater: String {
        NSLocalizedString(
            "prices.tryLater",
            comment: "Prompt asking the user to try the action again later"
        )
    }
    
    static var update: String {
        NSLocalizedString(
            "prices.update",
            comment: "Button title to refresh or update data"
        )
    }
}
