//
//  ProductsResponse.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import Foundation

protocol IProduct: Codable, Identifiable, Sendable {
    var id: Int { get set }
    var title: String { get set }
    var category: String { get set }
    var price: Double? { get set }
    var discountPercentage: Double? { get set }
    var thumbnail: String { get set } // url
    var globalSKU: String { get set }
    var localSKU: String { get set }
    var currency: Currency { get }
}



protocol IProductsResponse: Codable {
    var products: [Product] { get }
}

// MARK: - Response model
/// Represents the top-level response from the API containing a list of products.
struct ProductsResponse: IProductsResponse {
    let products: [Product]
}

// MARK: - Product model
/// Represents a single product with relevant details such as title, category, price, thumbnail, and identifiers.
/// Provides default values for SKU and currency for easier mock/testing usage.
struct Product: IProduct {
    var id: Int
    var title: String
    var category: String
    
    var price: Double?
    var discountPercentage: Double?
    
    var thumbnail: String
    var globalSKU: String
    var localSKU: String
    
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
    
    mutating func resetPriceAndDiscount() {
        self.price = nil
        self.discountPercentage = nil
    }
}


extension Product {
    init(model: any ILocalProduct) {
        self.id = model.id
        self.title = model.title
        self.category = model.category
        self.price = nil
        self.discountPercentage = nil
        self.thumbnail = model.thumbnail
        self.globalSKU = model.globalSKU
        self.localSKU = model.localSKU
        self.currency = .KZT 
    }
}
