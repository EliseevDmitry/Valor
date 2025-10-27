//
//  ProductsResponse.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import Foundation

protocol IProduct: Codable, Identifiable {
    var id: Int { get }
    var title: String { get }
    var category: String { get }
    var price: Double { get }
    var discountPercentage: Double { get }
    var thumbnail: String { get }
    var globalSKU: String { get }
    var localSKU: String { get }
    var currency: Currency { get }
}

// MARK: - Response model
/// Represents the top-level response from the API containing a list of products.
struct ProductsResponse: Codable {
    let products: [Product]
}

// MARK: - Product model
/// Represents a single product with relevant details such as title, category, price, thumbnail, and identifiers.
/// Provides default values for SKU and currency for easier mock/testing usage.
struct Product: Codable, Identifiable {
    let id: Int
    let title: String
    let category: String
    
    let price: Double
    let discountPercentage: Double
    
    let thumbnail: String
    let globalSKU: String
    let localSKU: String
    
    let currency: Currency
    
    // MARK: - Coding keys for decoding from API
    enum CodingKeys: String, CodingKey {
        case id, title, category, price, discountPercentage, thumbnail
    }
    
    // MARK: - Initializers
    /// Designated initializer with default values for SKU and currency.
    /// SKU and currency are generated locally and not retrieved from the server.
    init(
        id: Int,
        title: String,
        category: String,
        price: Double,
        discountPercentage: Double,
        thumbnail: String,
        globalSKU: String = Product.generateRandomDigitsString(),
        localSKU: String = "INT \(Product.generateRandomDigitsString())",
        currency: Currency = .KZT
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
    
    /// Decoder initializer used when decoding from JSON/API response.
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
    
    // MARK: - Utilities
    /// Generates a random numeric string used for SKUs.
    static func generateRandomDigitsString(length: Int = 10) -> String {
        return (0..<length)
            .map { _ in String(Int.random(in: 0...9)) }
            .joined()
    }
}
