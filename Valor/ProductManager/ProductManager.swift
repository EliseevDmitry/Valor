//
//  ProductManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation

enum URLProducts: String {
    case products = "https://dummyjson.com/products"
}

protocol IProductManager {
    func fetchData() async throws -> Data
    func getProducts<T: Decodable>(of type: T.Type, data: Data) throws -> T
}

final class ProductManager: IProductManager {
    func fetchData() async throws -> Data {
        guard let url = URL(string: URLProducts.products.rawValue) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try response.validate()
        return data
    }
}
