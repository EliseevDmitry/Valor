//
//  ProductManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation

/// Interface for fetching remote product data.
protocol IRemoteProductManager {
    func getEntity<T: Decodable>(of type: T.Type, url: URL?) async throws -> T
    func fetchData(url: URL?) async throws -> Data
}

/// Network manager for fetching remote data; uses generics to decode JSON into any `Decodable` type.
final class RemoteProductManager { }

//MARK: - Public functions

extension RemoteProductManager: IRemoteProductManager {
    
    /// Extension providing a generic method to decode JSON data into any `Decodable` type.
    func getEntity<T: Decodable>(of type: T.Type, url: URL?) async throws -> T {
        let data = try await fetchData(url: url)
        do {
            let objects = try JSONDecoder().decode(T.self, from: data)
            return objects
        } catch {
            throw error
        }
    }
    
    /// Fetches raw data asynchronously from a given URL.
    func fetchData(url: URL?) async throws -> Data {
        guard let url = url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        try response.validate()
        return data
    }
}
