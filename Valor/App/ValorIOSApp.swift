//
//  ValorIOSApp.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

@main
struct ValorIOSApp: App {
    init() {
        UINavigationBar.applyValorStyle()
    }
    @StateObject
    private var router = Router(startAt: .pricesAndDiscounts(.error))
    var body: some Scene {
        WindowGroup {
            RoutingView()
                .environmentObject(router)
        }
    }
}
