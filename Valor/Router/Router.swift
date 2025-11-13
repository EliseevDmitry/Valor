//
//  Router.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

/// Manages the app's current navigation state.
final class Router: ObservableObject {
    @Published var currentRoute: AppRoute?

    init(startAt route: AppRoute? = nil) {
        self.currentRoute = route
    }
}

// MARK: - Public functions
extension Router {
    /// push(_:) - sets the given route as the current screen.
    func push(_ route: AppRoute) {
        currentRoute = route
    }

    /// pop() - resets the route to the default error state.
    func pop() {
        currentRoute = .pricesAndDiscounts(.error)
    }
}
