//
//  Model.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [Product]
}

struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let thumbnail: String
    let globalSKU: String
    let localSKU: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case id, title, category, price, discountPercentage, thumbnail
    }

    init(
        id: Int,
        title: String,
        category: String,
        price: Double,
        discountPercentage: Double,
        thumbnail: String,
        globalSKU: String = Product.generateRandomDigitsString(),
        localSKU: String = "INT \(Product.generateRandomDigitsString())",
        currency: String = "USD"
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.price = price
        self.discountPercentage = discountPercentage
        self.thumbnail = thumbnail
        self.globalSKU = globalSKU
        self.localSKU = localSKU
        self.currency = currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let category = try container.decode(String.self, forKey: .category)
        let price = try container.decode(Double.self, forKey: .price)
        let discountPercentage = try container.decode(Double.self, forKey: .discountPercentage)
        let thumbnail = try container.decode(String.self, forKey: .thumbnail)

        self.init(
            id: id,
            title: title,
            category: category,
            price: price,
            discountPercentage: discountPercentage,
            thumbnail: thumbnail
        )
    }

    static func generateRandomDigitsString(length: Int = 10) -> String {
        return (0..<length)
            .map { _ in String(Int.random(in: 0...9)) }
            .joined()
    }
}
