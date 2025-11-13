//
//  Valor.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

@main
struct Valor: App {
    /// The UINavigationBar appearance configuration has been extracted into an extension
    /// via the static method `applyValorStyle()`. This allows centralized control over the
    /// navigation bar styling and ensures it is applied when the application launches.
    init() {
        UINavigationBar.applyValorStyle()
    }
    /// `@main` marks the application's entry point. Here, we initialize the root `Router`
    /// with the initial screen `.pricesAndDiscounts(.error)`, and inject it into the environment
    /// as an `environmentObject` for the root view `RoutingView`, which handles screen navigation.
    @StateObject
    private var router = Router(startAt: .pricesAndDiscounts(.error))
    var body: some Scene {
        WindowGroup {
            RoutingView()
                .environmentObject(router)
        }
    }
}
