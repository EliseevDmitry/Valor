//
//  PricesAndDiscountsViewModel.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import Foundation

enum LocalizePrices: String {
    case notFound = "Ничего не найдено"
    case fail = "Что-то пошло не так"
    case tryLater = "Попробуйте позднее"
    case update = "Обновить"
}

enum StatePricesView {
    case error, loading, empty
    
    var imageName: String? {
        switch self {
        case .error:
            CustomImage.errorView.rawValue
        case .empty:
            CustomImage.emptyView.rawValue
        case .loading:
            nil
        }
    }
}

final class PricesAndDiscountsViewModel: ObservableObject {
    
    @Published var isAnimating = false
    
    func isInternetReallyAvailable() async -> Bool {
        await Dependency.shared.internetManager.isInternetReallyAvailable()
    }
    
}
