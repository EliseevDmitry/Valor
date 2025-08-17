//
//  Extension+ProductManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation

extension ProductManager {
    func getProducts<T: Decodable>(of type: T.Type, data: Data) throws -> T {
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            return objects
        } catch {
            throw error
        }
    }
}
