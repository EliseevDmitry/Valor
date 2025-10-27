//
//  LocalProductManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 17.08.2025.
//

import Foundation
import CoreData

protocol ILocalProductManager {
    func addProducts(_ products: [any IProduct]) async throws -> Bool
    func getProducts<T: ILocalProduct>() async throws -> [T]
    func deleteAllProducts() async throws -> Bool
}

final class LocalProductManager: ILocalProductManager {
    
    enum CoreDataConstants {
        static let modelName = "ProductModel"
    }
    
    enum CoreDataError: LocalizedError {
        case saveFailed
        case fetchFailed(Error)
        case deleteFailed(Error)

        var errorDescription: String? {
            switch self {
            case .saveFailed:
                return "Failed to save data to Core Data."
            case .fetchFailed(let error):
                return "Failed to fetch data from Core Data. \(error.localizedDescription)"
            case .deleteFailed(let error):
                return "Failed to delete data from Core Data. \(error.localizedDescription)"
            }
        }
    }
    
    private let container: NSPersistentContainer
    
    init(container:
         NSPersistentContainer = NSPersistentContainer(
            name: CoreDataConstants.modelName
         )
    ) {
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
    }

    @discardableResult
    func deleteAllProducts() async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            deleteAllProducts { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

}

// MARK: - Private functions

extension LocalProductManager {

    private func fetchProductIDs(in context: NSManagedObjectContext) throws -> Set<Int16> {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: CoreDataConstants.modelName)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = ["id"]

        do {
            let results = try context.fetch(fetchRequest)
            return Set(results.compactMap { $0["id"] as? Int16 })
        } catch {
            throw CoreDataError.fetchFailed(error)
        }
    }

    private func fetchProducts(completion: @escaping (Result<[ProductModel], Error>) -> Void) {
        container.performBackgroundTask { context in
            let request = NSFetchRequest<ProductModel>(entityName: CoreDataConstants.modelName)
            do {
                let products = try context.fetch(request)
                completion(.success(products))
            } catch {
                completion(.failure(CoreDataError.fetchFailed(error)))
            }
        }
    }
    
    
    func addProducts(_ products: [any IProduct]) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            container.performBackgroundTask { context in
                do {
                    // Получаем уже существующие IDs
                    let productIDs = try self.fetchProductIDs(in: context)
                    let filteredProducts = products.filter { !productIDs.contains(Int16($0.id)) }

                    // Создаём новые объекты
                    for product in filteredProducts {
                        let newProduct = ProductModel(context: context)
                        newProduct.id = Int16(product.id)
                        newProduct.title = product.title
                        newProduct.category = product.category
                        newProduct.globalSKU = product.globalSKU
                        newProduct.localSKU = product.localSKU
                    }

                    try context.save()
                    continuation.resume(returning: true)
                } catch {
                    //вопрос?
                    if let coreError = error as? CoreDataError {
                        continuation.resume(throwing: coreError)
                    } else {
                        continuation.resume(throwing: CoreDataError.saveFailed)
                    }
                }
            }
        }
    }
    
    
   private func deleteAllProducts(completion: @escaping (Result<Bool, Error>) -> Void) {
        container.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductModel.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs
            do {
                let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes: [AnyHashable: Any] = [
                        NSDeletedObjectsKey: objectIDs
                    ]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.container.viewContext])
                }
                completion(.success(true))
            } catch {
                completion(.failure(CoreDataError.deleteFailed(error)))
            }
        }
    }

    
}


extension LocalProductManager {

    private func getProducts() async throws -> [ProductModel] {
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
