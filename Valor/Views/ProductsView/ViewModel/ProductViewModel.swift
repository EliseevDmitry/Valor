//
//  ProductViewModel.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import UIKit

enum LocalizeProducts: String {
    case all = "Все"
    case withoutPrice = "Товары без цены"
    case copyItem = "Скопировать артикул"
    case copyVlItem = "Скопировать артикул VL"
    case cancel = "Отмена"
    case copy = "Скопированный ID = "
}

enum PickerSegment: Int {
    case zero = 0
    case one = 1
}

final class ProductViewModel: ObservableObject {
    
    private var productManager: IProductRepository
    @Published var products: [Product] = []
    
    @Published var selectedProduct: Product? = nil
    @Published var showDialog = false
    @Published var showToast = false
    @Published var selectedSegment: PickerSegment
    
    init(manager: IProductRepository = ProductRepository(), selectedSegment: PickerSegment) {
        self.productManager = manager
        self.selectedSegment = selectedSegment
    }
    
    
    
    //вынести в отдельный сервис
    func copyID(id: String) {
        UIPasteboard.general.string = id
        Task { @MainActor in
            showToast = true
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showToast = false
        }
    }
    
    func showID() -> String {
        guard let message = UIPasteboard.general.string else { return ""}
        return message
    }
    
    func getProducts() {
        Task {
            do {
                let returnProducts = try await productManager.getProduct()
                await MainActor.run {
                    self.products = returnProducts.products
                    self.selectedSegment = returnProducts.segment
                }
            } catch {
                print("Ошибка получения данных: \(error)")
            }
            
        }
    }
    
    func getLocalProducts(router: Router) {
        productManager.delete()
        let products = productManager.getLocalProducts()
        if !products.isEmpty {
            self.products = products
        } else {
            router.push(.pricesAndDiscounts(.error))
        }
    }
    
}
