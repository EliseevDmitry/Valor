//
//  NavigationRoutes.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

/// Represents all possible screens and navigation routes in the app.
enum AppRoute: Hashable {
    case productsInternet
    case productsLocal
    case pricesAndDiscounts(StatePricesView)
}

//
extension AppRoute {
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .productsInternet:
            ProductsView()
        case .productsLocal:
            ProductsView()
        case .pricesAndDiscounts:
            PricesAndDiscountsView()
        }
    }
    
    var showsBackButton: Bool {
        switch self {
        case .pricesAndDiscounts(let state):
            return state != .loading && state != .error
        default:
            return true
        }
    }
}
