//
//  Extension+Product.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation

extension Product {
    var discountedPrice: Double {
        return price * (1 - discountPercentage / 100)
    }
}
