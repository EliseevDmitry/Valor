//
//  ProductViewModel.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import UIKit



enum PickerSegment: Int {
    case zero = 0
    case one = 1
}

final class ProductViewModel: ObservableObject {
    
    private var productManager: IProductRepository
    private var pasteboardManager: IPasteboardManager
    @Published var products: [Product] = []
    
    @Published var selectedProduct: Product? = nil
    @Published var showDialog = false
    @Published var showToast = false
    @Published var selectedSegment: PickerSegment
    
    
    
    init(
        productManager: IProductRepository = ProductRepository(),
        pasteboardManager: IPasteboardManager = PasteboardManager(),
        selectedSegment: PickerSegment
    ) {
        self.productManager = productManager
        self.selectedSegment = selectedSegment
        self.pasteboardManager = pasteboardManager
    }
    
    
    func copyID(id: String?) {
        guard let id = id else { return }
        pasteboardManager.copyID(id: id)
        showIDInToast()
    }
    
    func showID() -> String {
        guard let id = pasteboardManager.showID() else {
            return "no coping id"
        }
        return id
    }
    
    func select(_ product: Product) {
        selectedProduct = product
        showDialog = true
    }
    
    func segmentChanged(to segment: PickerSegment, router: Router) {
        switch segment {
        case .zero:
            break
        case .one:
            break
            //getLocalProducts(router: router)
        }
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
    
    private func showIDInToast() {
        Task { @MainActor in
            showToast = true
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showToast = false
        }
    }
}
