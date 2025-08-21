//
//  Extension+ProductManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation

/// Extension providing a generic method to decode JSON data into any `Decodable` type.
/// Simplifies parsing remote product data while preserving type safety and error propagation.
extension RemoteProductManager {
    func getProducts<T: Decodable>(of type: T.Type, data: Data) throws -> T {
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            return objects
        } catch {
            throw error
        }
    }
}
