//
//  ProductRepository.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 18.08.2025.
//

import Foundation
import Kingfisher
import UIKit

protocol IProductRepository {
    func getProduct() async throws -> [Product]
}


final class ProductRepository {
    private var remoteManager: IRemoteProductManager
    private var localManager: ILocalProductManager
    private var internetManager: INetworkMonitor
    
    init(
        remoteManager: IRemoteProductManager = RemoteProductManager(),
        localManager: ILocalProductManager = LocalProductManager(),
        internetManager: INetworkMonitor = NetworkMonitor()
    ) {
        self.remoteManager = remoteManager
        self.localManager = localManager
        self.internetManager = internetManager
    }

}

//MARK: - Public functions
extension ProductRepository {
    func getProduct() async throws -> [Product]{
        if await internetManager.isInternetReallyAvailable(){
            let data = try await remoteManager.fetchData()
            let response = try remoteManager.getProducts(of: ProductsResponse.self, data: data)
            _ = localManager.addProducts(response.products)
            return response.products
        } else {
            return localManager.getProducts()
        }
    }
}

//получение кэша у кингфишера
func getcachProto(url: String) async throws -> UIImage? {
 let image =  try await ImageCache.default.retrieveImage(forKey: url)
    guard let cacheImage = image.image?.cgImage else { return nil }
    return UIImage(cgImage: cacheImage)
}

//MARK: - Private functions
extension ProductRepository {
    
}
