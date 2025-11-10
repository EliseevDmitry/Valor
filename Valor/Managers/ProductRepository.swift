//
//  ProductRepository.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 18.08.2025.
//

import UIKit

/// Abstraction defining repository operations for product data management.
/// Handles data retrieval, image loading, and persistence operations.
protocol IProductRepository {
    func getProducts(url: URL?) async throws -> (products: [Product], isRemote: Bool)
    func getImage(url: String) async throws -> UIImage?
    func deleteProducts() async throws -> Bool
}

/// Repository coordinating local and remote product data sources.
/// Acts as a single entry point for fetching and caching product-related data.
final class ProductRepository {
    private var internetManager: INetworkMonitor
    private var remoteManager: IRemoteProductManager
    private var localManager: ILocalProductManager
    private var fileImageManager: IFileManager
    
    init(
        internetManager: INetworkMonitor = NetworkMonitor(),
        remoteManager: IRemoteProductManager = RemoteProductManager(),
        localManager: ILocalProductManager = LocalProductManager(),
        fileImageManager: IFileManager = FileManagerService()
    ) {
        self.internetManager = internetManager
        self.remoteManager = remoteManager
        self.localManager = localManager
        self.fileImageManager = fileImageManager
    }
}

//MARK: - Public functions (IProductRepository)

extension ProductRepository: IProductRepository {
    /// Retrieves product list from a remote or local source depending on network availability.
    /// Returns a tuple indicating the data source type.
    func getProducts(url: URL?) async throws -> (products: [Product], isRemote: Bool){
        switch await internetManager.isInternetAvailable(url: url){
        case true: let products = try await getRemoteProducts(url: url)
            return (products, true)
        case false:
            let products = try await getLocalProducts()
            return (products, false)
        }
    }
    
    /// Fetches an image either from cache, local storage, or remote source.
    /// Automatically caches remote images to disk and memory for future reuse.
    func getImage(url: String) async throws -> UIImage? {
        guard let url = URL(string: url) else { return nil }
        if let cachedImage = fileImageManager.getImage(url: url) {
            return cachedImage
        }
        let data = try await remoteManager.fetchData(url: url)
        guard let image = UIImage(data: data) else { return nil }
        try fileImageManager.addImage(image: image, url: url.absoluteString)
        return image
    }
    
    /// Deletes all locally stored product entities.
    func deleteProducts() async throws -> Bool {
        try await localManager.deleteAllProducts()
    }
}

//MARK: - Private functions

extension ProductRepository {
    /// Loads previously stored product data from the local database (Core Data).
    /// Converts persistent models into Product model instances.
    private func getLocalProducts() async throws -> [Product] {
        let localProducts: [LocalProduct] = try await localManager.getProducts()
        let products = localProducts.map { Product(model: $0) }
        return products
    }
    
    /// Fetches fresh product data from the backend and updates local storage.
    /// Decodes the network response into strongly typed models conforming to `IProductsResponse`.
    private func getRemoteProducts<T: IProductsResponse>(
        url: URL?,
        type: T.Type = ProductsResponse.self
    ) async throws -> [Product] {
        let productResponse = try await remoteManager.getEntity(of: type, url: url)
        let products = productResponse.products
        _ = try await localManager.addProducts(products)
        return products
    }
}
