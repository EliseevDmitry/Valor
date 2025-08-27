//
//  PricesAndDiscountsView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

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

struct PricesAndDiscountsView: View {
    @EnvironmentObject var router: Router
    @State private var isAnimating = false
    @StateObject private var viewModel = PricesAndDiscountsViewModel()
    var body: some View {
        ZStack {
            Color.vlColor.background.ignoresSafeArea()
            if case let .pricesAndDiscounts(state) = router.currentRoute {
                content(for: state)
            }
        }
        .dynamicTypeSize(.xLarge)
    }
    
    @ViewBuilder
    private func content(for state: StatePricesView) -> some View {
        switch state {
        case .loading:
            //LoadingCircleView(isAnimating: $isAnimating)
            LoadingCircleView()
        case .empty:
            emptyStateView(imageName: state.imageName)
        case .error:
            errorStateView(imageName: state.imageName)
        }
    }
    
    private func emptyStateView(imageName: String?) -> some View {
        VStack(spacing: 12) {
            stateImage(imageName)
            Text(LocalizePrices.notFound.rawValue)
                .font(.titleSFProRegular18())
                .foregroundStyle(Color.vlColor.text)
        }
        .onAppear { isAnimating = false }
    }
    
    private func errorStateView(imageName: String?) -> some View {
        VStack(spacing: 16) {
            stateImage(imageName)
            VStack(spacing: 8) {
                Text(LocalizePrices.fail.rawValue)
                    .font(.titleABeeZeeRegular18())
                    .foregroundStyle(Color.vlColor.text)
                Text(LocalizePrices.tryLater.rawValue)
                    .font(.titleABeeZeeRegular18())
                    .foregroundStyle(Color.vlColor.textPrimary)
            }
            PrimaryButton(
                title: LocalizePrices.update.rawValue,
                iconName: CustomImage.button.rawValue,
                action: { await viewModel.loadData(router: router)}
            )
        }
        .padding()
        .onAppear { isAnimating = false }
    }
    
    private func stateImage(_ name: String?) -> some View {
        Group {
            if let name { Image(name) }
        }
    }
}

#Preview {
    NavigationView(content: {
        PricesAndDiscountsView()
            .navigationTitle(LocalizeRouting.title)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
    })
}
