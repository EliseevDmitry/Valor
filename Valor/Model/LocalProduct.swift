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
    var url: URL { get }
    var globalSKU: String { get }
    var localSKU: String { get }
    init(id: Int, title: String, category: String, url: URL, globalSKU: String, localSKU: String)
}


struct LocalProduct: ILocalProduct {
    let id: Int
    let title: String
    let category: String
    let url: URL
    let globalSKU: String
    let localSKU: String
}
