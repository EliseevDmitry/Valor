//
//  RoutingView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

/// Intermediate navigation layer for the app.
/// Handles:
/// 1. Rendering the current route's content.
/// 2. Providing consistent navigation properties (title, display mode, safe area handling).
/// 3. Managing the back button toolbar for all screens.
struct RoutingView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationView {
            VStack {
                router.currentRoute?.destinationView
            }
            .navigationTitle(LocalizeRouting.title)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                backToolbar
            }
        }
    }
    
    /// ToolbarItem for the back button.
    /// Displayed only if the current route allows going back.
    @ToolbarContentBuilder
    private var backToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if let route = router.currentRoute, route.showsBackButton {
                Button(action: { router.pop() }) {
                    Image(systemName: CustomImage.backButton.rawValue)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    let router = Router()
    router.currentRoute = .pricesAndDiscounts(.error)
    return RoutingView()
        .environmentObject(router)
}
