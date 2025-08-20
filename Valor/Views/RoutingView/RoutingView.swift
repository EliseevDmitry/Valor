//
//  ContentView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

enum LocalizeRouting: String {
    case title = "Цены и скидки"
}

struct RoutingView: View {
    @EnvironmentObject var router: Router
    var body: some View {
        NavigationView {
            VStack {
                if let route = router.currentRoute {
                    destinationView(for: route)
                } else {
                    PricesAndDiscountsView(loadingState: .constant(.loading))
                }
            }
            .navigationTitle(LocalizeRouting.title.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if shouldShowBackButton() {
                        backButton
                    }
                }
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            router.pop()
        }) {
            Image(systemName: CustomImage.backButton.rawValue)
                .foregroundColor(.blue)
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .productsInternet:
            ProductsView(selectedSegment: PickerSegment.zero)
        case .productsLocal:
            ProductsView(selectedSegment: PickerSegment.one)
        case .pricesAndDiscounts(let state):
            PricesAndDiscountsView(loadingState: .constant(state))
        }
    }
    
    private func shouldShowBackButton() -> Bool {
        guard let route = router.currentRoute else { return false }
        switch route {
        case .pricesAndDiscounts(let state):
            return state != .error
        default:
            return true
        }
    }
    
}

//#Preview {
//    RoutingView(router: )
//}
