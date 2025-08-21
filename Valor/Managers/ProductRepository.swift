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
    func getLocalProducts() -> [Product]
    func getRemoteProducts() async throws -> [Product]
    func getProduct() async throws -> (products: [Product], segment: PickerSegment)
    //удалить функцию
    func delete()
}


final class ProductRepository: IProductRepository {
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
    
    func getLocalProducts() -> [Product] {
        localManager.getProducts()
    }
    
    func getRemoteProducts() async throws -> [Product] {
        let data = try await remoteManager.fetchData()
        let response = try remoteManager.getProducts(of: ProductsResponse.self, data: data)
        _ = localManager.addProducts(response.products)
        return response.products
    }
    
    func getProduct() async throws -> (products: [Product], segment: PickerSegment){
        if await internetManager.isInternetAvailable(){
            let products = try await getRemoteProducts()
            return (products, .zero)
        } else {
            return (getLocalProducts(), .one)
        }
    }
    
  
    func delete(){
      _ = localManager.deleteAllProducts()
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
