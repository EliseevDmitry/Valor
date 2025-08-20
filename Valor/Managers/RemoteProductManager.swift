//
//  ProductManager.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import Foundation

enum URLProducts {
    case products
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        switch self {
        case .products:
            components.scheme = "https"
            components.host = "dummyjson.com"
            components.path = "/products"
        }
        return components
    }
    
    var url: URL? {
        urlComponents.url
    }
}

protocol IRemoteProductManager {
    func fetchData(url: URL?) async throws -> Data
    func getProducts<T: Decodable>(of type: T.Type, data: Data) throws -> T
}

//MARK: - Public functions
extension IRemoteProductManager {
    func fetchData() async throws -> Data {
        try await fetchData(url: URLProducts.products.url)
    }
}

final class RemoteProductManager: IRemoteProductManager { }

//MARK: - Public functions
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
