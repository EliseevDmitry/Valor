//
//  NavigationRoutes.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

/// Represents all possible screens and navigation routes in the app.
enum AppRoute: Hashable {
    case products
    case pricesAndDiscounts(StatePricesView)
}

/// Provides view mapping and navigation behavior for each AppRoute case.
/// `destinationView` returns the corresponding screen.
/// `showsBackButton` defines back button visibility based on route state.
extension AppRoute {
    @ViewBuilder
    var destinationView: some View {
        switch self {
        case .products:
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
