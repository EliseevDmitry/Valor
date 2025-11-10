//
//  LocalProduct.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 23.10.2025.
//

import Foundation

protocol ILocalProduct: Codable, Identifiable {
    var id: Int { get }
    var title: String { get }
    var category: String { get }
    var thumbnail: String { get }
    var globalSKU: String { get }
    var localSKU: String { get }
    init(id: Int, title: String, category: String, thumbnail: String, globalSKU: String, localSKU: String)
    init?(model: ProductModel)
}

struct LocalProduct: ILocalProduct {
    let id: Int
    let title: String
    let category: String
    let thumbnail: String
    let globalSKU: String
    let localSKU: String
    
    init(
        id: Int,
        title: String,
        category: String,
        thumbnail: String,
        globalSKU: String,
        localSKU: String
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.thumbnail = thumbnail
        self.globalSKU = globalSKU
        self.localSKU = localSKU
    }
    
    init?(model: ProductModel) {
        guard
            let title = model.title,
            let category = model.category,
            let thumbnail = model.thumbnail,
            let globalSKU = model.globalSKU,
            let localSKU = model.localSKU
        else { return nil }
        
        self.id = Int(model.id)
        self.title = title
        self.category = category
        self.thumbnail = thumbnail
        self.globalSKU = globalSKU
        self.localSKU = localSKU
    }
}
