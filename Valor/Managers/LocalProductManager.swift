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
    func addProducts(_ products: [Product]) -> Bool
    func getProducts<T: ILocalProduct>() async throws -> [T]
   // func getImageURLByID(idProduct: Int) -> URL?
    
   // func productsIsEmpty() throws -> Bool
    //удалить функцию
   // func deleteAllProducts() -> Bool
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
    //сохраняем только не существующие в базе элементы
    func addProducts(_ products: [Product]) -> Bool {
        let productIDs = fetchProductIDs()
        let filteredProducts = products.filter { !productIDs.contains(Int16($0.id)) }
        for product in filteredProducts {
            let newProduct = ProductModel(context: container.viewContext)
            newProduct.id = Int16(product.id)
            newProduct.title = product.title
            newProduct.category = product.category
            newProduct.globalSKU = product.globalSKU
            newProduct.localSKU = product.localSKU
        }
        return saveData()
    }

    
    //в теории метод возвращает URL - который хранится в файл менеджере
//    func getImageURLByID(idProduct: Int) -> URL? {
//        let request = NSFetchRequest<ProductModel>(entityName: CoreDataConstants.modelName)
//        request.predicate = NSPredicate(format: "id == %d", Int16(idProduct))
//            request.fetchLimit = 1
//            do {
//                guard let productModel = try container.viewContext.fetch(request).first,
//                      let path = productModel.thumbnail else {
//                    return nil
//                }
//                return URL(string: path)
//            } catch {
//                print("Error fetching product by id: \(error)")
//                return nil
//            }
//    }
    
    //получаем данные из CoreData (должен быть бэграунд поток)
    func getProducts<T: ILocalProduct>() async throws -> [T] {
        let products = try await getProducts()
        return products.compactMap { products in
            guard
                let title = products.title,
                let category = products.category,
                let url = products.url,
                let globalSKU = products.globalSKU,
                let localSKU = products.localSKU
            else { return nil }
            return T(
                id: Int(products.id),
                title: title,
                category: category,
                url: url,
                globalSKU: globalSKU,
                localSKU: localSKU
            )
        }
//        return fechProducts().compactMap { productModel in
//            guard
//                let title = productModel.title,
//                let category = productModel.category,
//                let url = productModel.url,
//                let globalSKU = productModel.globalSKU,
//                let localSKU = productModel.localSKU
//            else { return nil }
//            return LocalProduct(
//                id: Int(productModel.id),
//                title: title,
//                category: category,
//                url: url,
//                globalSKU: globalSKU,
//                localSKU: localSKU
//            )
//        }
    }
    
//    func getProducts() -> [Product] {
//        return fechProducts().compactMap { productModel in
//            guard
//                let title = productModel.title,
//                let category = productModel.category,
//                let thumbnail = productModel.url?.absoluteString
//            else { return nil }
//            return Product(
//                id: Int(productModel.id),
//                title: title,
//                category: category,
//                price: nil,
//                discountPercentage: nil,
//                thumbnail: thumbnail,
//                globalSKU: productModel.globalSKU,
//                localSKU: productModel.localSKU
//            )
//        }
//    }
    
    func productsIsEmpty() throws -> Bool {
        let request = NSFetchRequest<ProductModel>(entityName: CoreDataConstants.modelName)
        return try container.viewContext.count(for: request) == 0
    }
    
    //не знаю нужна ли эта функция?
    func deleteAllProducts() -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductModel.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try container.viewContext.execute(batchDeleteRequest)
            try container.viewContext.save()
            return true
        } catch {
            print("Ошибка удаления всех продуктов: \(error)")
            return false
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
    
    //переделать id через codable
    //получение уникальных id
    private func fetchProductIDs() -> Set<Int16> {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: CoreDataConstants.modelName)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]

        var productIDs = Set<Int16>()
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            productIDs = Set(results.compactMap { $0["id"] as? Int16 })
        } catch {
            print("Ошибка выборки id: \(error)")
        }
        return productIDs
    }
    
    
    
    //запрос в CoreData в фоновом потоке
    private func fetchProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        container.performBackgroundTask { context in
            let request = NSFetchRequest<ProductModel>(entityName: CoreDataConstants.modelName)
            do {
                let products = try context.fetch(request)
                completion(.success(products))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    
}


extension LocalProductManager {
    
    //обертка fetchProducts в симантике async/await
    func getProducts() async throws -> [ProductModel] {
     try await withCheckedThrowingContinuation { continuation in
            fetchProducts { result in
                switch result {
                case .success(let products):
                    continuation.resume(returning: products)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
