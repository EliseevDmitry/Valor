//
//  ProductManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation



protocol IRemoteProductManager {
    func getEntity<T: Decodable>(of type: T.Type, url: URL?) async throws -> T
    func fetchData(url: URL?) async throws -> Data
}

final class RemoteProductManager { }

//MARK: - Public functions

/// Extension providing a generic method to decode JSON data into any `Decodable` type.
/// Simplifies parsing remote product data while preserving type safety and error propagation.
extension RemoteProductManager: IRemoteProductManager {
    func getEntity<T: Decodable>(of type: T.Type, url: URL?) async throws -> T {
        let data = try await fetchData(url: url)
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            return objects
        } catch {
            throw error
        }
    }
}

//MARK: - Private functions

extension RemoteProductManager {
    func fetchData(url: URL?) async throws -> Data {
        guard let url = url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try response.validate()
        return data
    }
}
