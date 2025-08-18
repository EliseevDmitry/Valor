//
//  LocalProductManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 17.08.2025.
//

import Foundation
import CoreData

enum CoreDataConstants {
    static let modelName = "ProductModel"
}

protocol ILocalProductManager {
//    func addProduct(_ product: Product) -> Bool
    func addProducts(_ products: [Product]) -> Bool
    func getImageURLByID(idProduct: Int) -> URL?
    func getProducts() -> [Product]
}

final class LocalProductManager: ILocalProductManager {
    private let container: NSPersistentContainer
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: CoreDataConstants.modelName)) {
        self.container = container
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
}

// MARK: - Public functions
extension LocalProductManager {
    
//    @discardableResult
//    func addProduct(_ product: Product) -> Bool {
//        let newProduct = ProductModel(context: container.viewContext)
//        newProduct.id = Int16(product.id)
//        newProduct.title = product.title
//        newProduct.category = product.category
//        newProduct.price = product.price
//        newProduct.discountPercentage = product.discountPercentage
//        newProduct.thumbnail = product.thumbnail
//        newProduct.globalSKU = product.globalSKU
//        newProduct.localSKU = product.localSKU
//        newProduct.currency = product.currency
//        return saveData()
//    }
    
   
    func addProducts(_ products: [Product]) -> Bool {
        for product in products {
            let newProduct = ProductModel(context: container.viewContext)
            newProduct.id = Int16(product.id)
            newProduct.title = product.title
            newProduct.category = product.category
            newProduct.price = product.price
            newProduct.discountPercentage = product.discountPercentage
            newProduct.thumbnail = product.thumbnail
            newProduct.globalSKU = product.globalSKU
            newProduct.localSKU = product.localSKU
            newProduct.currency = product.currency
        }
        return saveData()
    }
    
    //в теории метод возвращает URL - который хранится в файл менеджере
    func getImageURLByID(idProduct: Int) -> URL? {
        let request = NSFetchRequest<ProductModel>(entityName: CoreDataConstants.modelName)
        request.predicate = NSPredicate(format: "id == %d", Int16(idProduct))
            request.fetchLimit = 1
            do {
                guard let productModel = try container.viewContext.fetch(request).first,
                      let path = productModel.thumbnail else {
                    return nil
                }
                return URL(string: path)
            } catch {
                print("Error fetching product by id: \(error)")
                return nil
            }
    }
    
    func getProducts() -> [Product] {
        return fechProducts().compactMap { productModel in
            guard
                let title = productModel.title,
                let category = productModel.category,
                let thumbnail = productModel.thumbnail
            else { return nil }
            return Product(
                id: Int(productModel.id),
                title: title,
                category: category,
                price: productModel.price,
                discountPercentage: productModel.discountPercentage,
                thumbnail: thumbnail
            )
        }
    }
    
}

// MARK: - Private functions
extension LocalProductManager {
    private func saveData() -> Bool {
        do{
            try container.viewContext.save()
            return true
        } catch let error {
            print("Error saving  data to Core Data. \(error.localizedDescription)")
            return false
        }
    }
    
    private func fechProducts() -> [ProductModel]{
        let request = NSFetchRequest<ProductModel>(entityName: CoreDataConstants.modelName)
        do{
            return try container.viewContext.fetch(request)
        } catch let error {
            print("Error request Core Data \(error.localizedDescription)")
            return []
        }
    }
}
