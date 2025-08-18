//
//  ProductRepository.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 18.08.2025.
//

import Foundation

protocol IProductRepository {
    func getProduct() async throws -> [Product]
}


final class ProductRepository {
    private var remoteManager: IRemoteProductManager
    private var localManager: ILocalProductManager
    private var internetManager: IInternetManager
    
    init(
        remoteManager: IRemoteProductManager = RemoteProductManager(),
        localManager: ILocalProductManager = LocalProductManager(),
        internetManager: IInternetManager = InternetManager()
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

//MARK: - Private functions
extension ProductRepository {
    
}
