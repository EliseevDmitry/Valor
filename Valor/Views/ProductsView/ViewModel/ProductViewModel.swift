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
    
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var images: [Int : UIImage] = [:] // [product.id : image]
    
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
            getProducts()
        case .one:
            getLocalData()
        }
    }
    
    /// сделать allert
    
    func getProducts() {
        products = []
        Task {
            do {
                let returnProducts = try await productManager.getProducts(url: URLProducts.allProducts.url)
                await MainActor.run {
                    self.products = returnProducts.products
                    let segment = getPickerSegment(isRemote: returnProducts.isRemote)
                    self.selectedSegment = segment
                }
                self.getImages(for: returnProducts.products)
            } catch {
                print("Ошибка получения данных: \(error)")
            }
            
        }
    }
    
    private func getImages(for products: [Product]) {
        Task.detached {
            for product in products {
                do {
                    if let image = try await self.productManager.getImage(url: product.thumbnail) {
                        await MainActor.run {
                            self.images[product.id] = image
                        }
                    }
                } catch {
                    //print("Ошибка загрузки изображения \(url): \(error)")
                }
            }
        }
    }
    
    func delete(){
        Task {
            do {
                _ = try await productManager.deleteProducts()
            } catch {
                
            }
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


extension ProductViewModel {
    
    ///
    func getPickerSegment(isRemote: Bool) -> PickerSegment {
        switch isRemote {
        case true:
            return .zero
        case false:
            return .one
        }
    }
    
    func getLocalData() {
        guard !products.isEmpty else {
            getProducts()
            return
        }
       
        products = products.map { product in
            var mutableProduct = product
            mutableProduct.resetPriceAndDiscount()
            return mutableProduct
        }
    }
}
