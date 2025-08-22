//
//  CustomImage.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import Foundation

/// Enum providing a centralized and type-safe way to reference image assets.
/// Images are stored in `Assets.xcassets`, with separate folders for each screen.
/// The case names are designed to be concise and meaningful, while the raw values
/// match the exported names from Figma design files for consistency and ease of maintenance.
enum CustomImage: String {
    //Assets images
    case button = "refreshicon"
    case errorView = "illustration-circle-error"
    case emptyView = "illustration-flashlight-guide"
    case burgerPoints = "morehorizontal"
    //systemImages SF
    case photo = "photo"
    case backButton = "chevron.left"
}

//Routing View
enum LocalizeRouting {
    static let title = "Prices and Discounts"
}

//ProductsView
enum LocalizeProducts: String {
    case all = "Все"
    case withoutPrice = "Товары без цены"
    case copyItem = "Скопировать артикул"
    case copyVlItem = "Скопировать артикул VL"
    case cancel = "Отмена"
    case copy = "Скопированный ID = "
}

//PricesAndDiscountsView
enum LocalizePrices: String {
    case notFound = "Ничего не найдено"
    case fail = "Что-то пошло не так"
    case tryLater = "Попробуйте позднее"
    case update = "Обновить"
}
