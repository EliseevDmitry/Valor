//
//  LocalizeProductCard.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 27.08.2025.
//

import SwiftUI

/// Provides localized strings and formatted messages for product card details.
/// Includes SKU prefixes, price labels, and discount-related texts.
/// Supports dynamic SKU insertion with formatted string methods.
enum LocalizeProductCard {
    static func skuGlobal(_ sku: String) -> String {
        String(
            format: NSLocalizedString(
                "product.sku.global",
                comment: "Global SKU prefix for product item"
            ),
            sku
        )
    }
    static func skuLocal(_ sku: String) -> String {
        String(
            format: NSLocalizedString(
                "product.sku.local",
                comment: "Local SKU prefix for product item"
            ),
            sku
        )
    }
    static var price: String {
        NSLocalizedString(
            "product.price",
            comment: ""
        )
    }
    static var discounts: String {
        NSLocalizedString(
            "product.discounts",
            comment: ""
        )
    }
    static var priceWithDiscounts: String { NSLocalizedString(
        "product.priceWithDiscounts",
        comment: ""
    )
    }
}
