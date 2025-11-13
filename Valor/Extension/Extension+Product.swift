//
//  Extension+Product.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation

/// Returns the product price after applying the discount percentage.
/// Ensures the discount is between 0% and 100%.
extension Product {
    var discountedPrice: Double? {
        guard
            let price,
            let discountPercentage
        else { return nil }
        let validDiscount = min(max(discountPercentage, 0), 100)
        return price * (1 - validDiscount / 100)
    }
}
