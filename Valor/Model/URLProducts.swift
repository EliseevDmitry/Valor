//
//  URLProducts.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 29.08.2025.
//

import Foundation

/// Defines API endpoints for retrieving products from DummyJSON.
/// Supports fetching all products or paginated results with limit and skip.
/// Provides a computed `url` for each case.  
enum URLProducts {
    case allProducts
    case products(limit: Int, skip: Int)
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dummyjson.com"
        
        switch self {
        case .allProducts:
            components.path = "/products"
        case let .products(limit, skip):
            components.path = "/products"
            components.queryItems = [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "skip", value: "\(skip)")
            ]
        }
        
        return components
    }
    
    var url: URL? {
        urlComponents.url
    }
}
