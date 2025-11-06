//
//  ProductRepository.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 18.08.2025.
//

import UIKit

protocol IProductRepository {
    func getProducts(url: URL?) async throws -> (products: [Product], isRemote: Bool)
    func getImage(url: String) async throws -> UIImage?
    func deleteProducts() async throws -> Bool
}

final class ProductRepository {
    
    private var remoteManager: IRemoteProductManager
    private var localManager: ILocalProductManager
    private var internetManager: INetworkMonitor
    private var fileImageManager: IFileManager
    
    init(
        remoteManager: IRemoteProductManager = RemoteProductManager(),
        localManager: ILocalProductManager = LocalProductManager(),
        internetManager: INetworkMonitor = NetworkMonitor(),
        fileImageManager: IFileManager = FileManagerService()
    ) {
        self.remoteManager = remoteManager
        self.localManager = localManager
        self.internetManager = internetManager
        self.fileImageManager = fileImageManager
    }
}

//MARK: - Public functions (IProductRepository)

extension ProductRepository: IProductRepository {
    
    func getProducts(url: URL?) async throws -> (products: [Product], isRemote: Bool){
        switch await internetManager.isInternetAvailable() {
        case true: let products = try await getRemoteProducts(url: url)
            return (products, true)
        case false:
            let products = try await getLocalProducts()
            return (products, false)
        }
    }
    
    /// Загрузка фотографий из сети или локального хранилища
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
    
    func deleteProducts() async throws -> Bool {
        try await localManager.deleteAllProducts()
    }
    
}

//MARK: - Private functions

extension ProductRepository {
    
    /// Получение локального продукта из CoreData
    private func getLocalProducts() async throws -> [Product] {
        let localProducts: [LocalProduct] = try await localManager.getProducts()
        let products = localProducts.map { Product(model: $0) }
        return products
    }
    
    /// Получение из сети новых продуктов
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
