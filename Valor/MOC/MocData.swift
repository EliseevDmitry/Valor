//
//  MocData.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import Foundation

/// Mock data for previews and manual testing.
struct MocData {
    static let testProduct = Product(
        id: 1,
        title: "iPhone 16 Pro Max",
        category: "phones",
        price: 550,
        discountPercentage: 10,
        thumbnail: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp",
        currency: .USD
    )
    static let screenWidth: CGFloat = 375
}
