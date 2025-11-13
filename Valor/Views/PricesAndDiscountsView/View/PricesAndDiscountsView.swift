//
//  PricesAndDiscountsView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

/// - добавить комментарий
struct PricesAndDiscountsView: View {
    @EnvironmentObject var router: Router
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
}

// MARK: - Private functions

extension PricesAndDiscountsView {
    enum Const {
        static let emptyStateSpacing: CGFloat = 12
        static let errorStateMainSpacing: CGFloat = 16
        static let errorStateInnerSpacing: CGFloat = 8
        static let errorStatePadding: CGFloat = 16
    }
    
    @ViewBuilder
    private func content(for state: StatePricesView) -> some View {
        switch state {
        case .loading:
            LoadingCircleView()
        case .empty:
            emptyStateView(imageName: state.imageName)
        case .error:
            errorStateView(imageName: state.imageName)
        }
    }
    
    private func emptyStateView(imageName: String?) -> some View {
        VStack(spacing: Const.emptyStateSpacing) {
            stateImage(imageName)
            Text(LocalizePrices.notFound)
                .font(.titleSFProRegular18())
                .foregroundStyle(Color.vlColor.text)
        }
    }
    
    private func errorStateView(imageName: String?) -> some View {
        VStack(spacing: Const.errorStateMainSpacing) {
            stateImage(imageName)
            VStack(spacing: Const.errorStateInnerSpacing) {
                Text(LocalizePrices.fail)
                    .font(.titleABeeZeeRegular18())
                    .foregroundStyle(Color.vlColor.text)
                Text(LocalizePrices.tryLater)
                    .font(.titleABeeZeeRegular18())
                    .foregroundStyle(Color.vlColor.textPrimary)
            }
            PrimaryButton(
                title: LocalizePrices.update,
                iconName: CustomImage.button.rawValue,
                // проверить await!!!
                action: { await viewModel.loadData(router: router) }
            )
        }
        .padding(Const.errorStatePadding)
    }
    
    @ViewBuilder
    private func stateImage(_ name: String?) -> some View {
        if let name {
            Image(name)
        } else {
            EmptyView()
        }
    }
}

// MARK: - Prewiew

#Preview {
    NavigationView {
        PricesAndDiscountsView()
            .environmentObject(Router())
            .navigationTitle(LocalizeRouting.title)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
    }
}
