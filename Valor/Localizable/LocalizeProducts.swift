//
//  LocalizeProducts.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 28.08.2025.
//

import SwiftUI

/// Provides localized strings for product-related UI elements.
/// Includes titles for segmented controls and confirmation dialogs.
/// Supports formatted messages for dynamic content like copied IDs.
enum LocalizeProducts {
    static var all: String {
        NSLocalizedString(
            "products.all",
            comment: "Segment title for 'All Products' in UISegmentedControl (index 0)"
        )
    }
    
    static var withoutPrice: String {
        NSLocalizedString(
            "products.withoutPrice",
            comment: "Segment title for 'Without Price' in UISegmentedControl (index 1)"
        )
    }
    
    static var copyItem: String {
        NSLocalizedString(
            "products.copyItem",
            comment: "ConfirmationDialog button title for copying the item number (index 0)"
        )
    }
    
    static var copyVlItem: String {
        NSLocalizedString(
            "products.copyVlItem",
            comment: "ConfirmationDialog button title for copying the internal item number (index 1)"
        )
    }
    
    static var cancel: String {
        NSLocalizedString(
            "products.cancel",
            comment: "ConfirmationDialog cancel button title (index 2)"
        )
    }
    
    static func copy(_ sku: String) -> String {
        String(
            format: NSLocalizedString(
                "products.copy",
                comment: "ToastView message prefix for copied ID information"
            ),
            sku
        )
    }
}
