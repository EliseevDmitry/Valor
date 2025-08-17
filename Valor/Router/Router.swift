//
//  Router.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

enum AppRoute: Hashable {
    case productsInternet
    case productsLocal
    case pricesAndDiscounts(StatePricesView)
}

final class Router: ObservableObject {
    @Published var currentRoute: AppRoute?

    init(startAt route: AppRoute? = nil) {
        self.currentRoute = route
    }

    func push(_ route: AppRoute) {
        currentRoute = route
    }

    func pop() {
        currentRoute = .pricesAndDiscounts(.error)
    }
}
