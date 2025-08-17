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
    private var productManager: IRemoteProductManager
    @Published var products: [Product] = []
    @Published var selectedProduct: Product? = nil
    @Published var showDialog = false
    @Published var showToast = false
    @Published var selectedSegment: PickerSegment

    init(manager: IRemoteProductManager, selectedSegment: PickerSegment) {
        self.productManager = manager
        self.selectedSegment = selectedSegment
    }

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
                let data = try await productManager.fetchData()
                let decoded = try productManager.getProducts(of: ProductsResponse.self, data: data)
                
                await MainActor.run {
                    self.products = decoded.products
                }
            } catch {
                print("Ошибка получения данных: \(error)")
            }
        }
    }
    
    func isInternetReallyAvailable() async -> Bool {
        await Dependency.shared.internetManager.isInternetReallyAvailable()
    }

}
