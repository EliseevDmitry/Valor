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
    let title: String
    let category: String
    let price: Double
    let discountPercentage: Double
    let thumbnail: String

    let uniqID: UUID
    let id: String
    let vlId: String
    let currency: String

    enum CodingKeys: String, CodingKey {
        case title, category, price, discountPercentage, thumbnail
    }

    init(
        title: String,
        category: String,
        price: Double,
        discountPercentage: Double,
        thumbnail: String,
        uniqID: UUID = UUID(),
        id: String = Product.generateRandomDigitsString(),
        vlId: String = "VL \(Product.generateRandomDigitsString())",
        currency: String = "RUB"
    ) {
        self.title = title
        self.category = category
        self.price = price
        self.discountPercentage = discountPercentage
        self.thumbnail = thumbnail
        self.uniqID = uniqID
        self.id = id
        self.vlId = vlId
        self.currency = currency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let title = try container.decode(String.self, forKey: .title)
        let category = try container.decode(String.self, forKey: .category)
        let price = try container.decode(Double.self, forKey: .price)
        let discountPercentage = try container.decode(Double.self, forKey: .discountPercentage)
        let thumbnail = try container.decode(String.self, forKey: .thumbnail)

        self.init(
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
