//
//  LocalProductManager.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 17.08.2025.
//

import Foundation
import CoreData

/// Defines a Core Data–backed service for managing local product persistence.
protocol ILocalProductManager: Sendable {
    func addProducts(_ products: [any IProduct]) async throws -> Bool
    func getProducts<T: ILocalProduct>() async throws -> [T]
    func deleteAllProducts() async throws -> Bool
}

/// Concrete Core Data implementation handling product CRD operations.
final class LocalProductManager {
    
    enum Consts {
        static let modelName = "ProductModel"
        static let idFieldName = "id"
    }
    
    enum CoreDataError: LocalizedError {
        case saveFailed(Error)
        case fetchFailed(Error)
        case deleteFailed(Error)
        
        var errorDescription: String? {
            switch self {
            case .saveFailed(let error):
                return "Failed to save data to Core Data. \(error.localizedDescription)"
            case .fetchFailed(let error):
                return "Failed to fetch data from Core Data. \(error.localizedDescription)"
            case .deleteFailed(let error):
                return "Failed to delete data from Core Data. \(error.localizedDescription)"
            }
        }
    }
    
    private let container: NSPersistentContainer
    private let backgroundContext: NSManagedObjectContext
    
    init(
        container: NSPersistentContainer = NSPersistentContainer(name: Consts.modelName)
    ) {
        self.container = container
        let semaphore = DispatchSemaphore(value: 0)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data load error: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        semaphore.wait()
        self.backgroundContext = container.newBackgroundContext()
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}

// MARK: - Public functions

extension LocalProductManager: ILocalProductManager {
    /// Inserts new product entities using a private background context to ensure thread safety.
    func addProducts(_ products: [any IProduct]) async throws -> Bool {
        let context = self.backgroundContext
        let createModel = self.createProductModel
        let fetchIDs = self.fetchProductIDs
        return try await context.perform {
            let productIDs = try fetchIDs(context)
            let filteredProducts = products.filter { !productIDs.contains(Int32($0.id)) }
            for product in filteredProducts {
                createModel(product, context)
            }
            do {
                try context.save()
                return true
            } catch {
                throw CoreDataError.saveFailed(error)
            }
        }
    }
    
    /// Fetches all stored products and converts them into strongly typed local models.
    func getProducts<T: ILocalProduct>() async throws -> [T] {
        let context = self.backgroundContext
        return try await context.perform {
            let request = NSFetchRequest<ProductModel>(entityName: Consts.modelName)
            let models = try context.fetch(request)
            return self.convertProducts(models: models)
        }
    }
    
    /// Executes a batch delete to remove all product entities efficiently.
    func deleteAllProducts() async throws -> Bool {
        let context = self.backgroundContext
        return try await context.perform {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProductModel.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeCount
            _ = try context.execute(deleteRequest)
            context.reset()
            return true
        }
    }
}

// MARK: - Private functions

private extension LocalProductManager {
    /// Retrieves all product IDs in Core Data to avoid duplicate inserts.
    func fetchProductIDs(in context: NSManagedObjectContext) throws -> Set<Int32> {
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: Consts.modelName)
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.propertiesToFetch = [Consts.idFieldName]
        let results = try context.fetch(fetchRequest)
        return Set(results.compactMap { $0[Consts.idFieldName] as? Int32 })
    }
    
    /// Maps an IProduct into a Core Data ProductModel and inserts it into the context.
    func createProductModel(product: any IProduct, context: NSManagedObjectContext) {
        let newProduct = ProductModel(context: context)
        newProduct.id = Int32(product.id)
        newProduct.title = product.title
        newProduct.category = product.category
        newProduct.thumbnail = product.thumbnail
        newProduct.globalSKU = product.globalSKU
        newProduct.localSKU = product.localSKU
    }
    
    /// Converts fetched Core Data models into type-safe ILocalProduct instances.
    func convertProducts<T: ILocalProduct>(models: [ProductModel]) -> [T] {
        models.compactMap { T(model: $0) }
    }
}
