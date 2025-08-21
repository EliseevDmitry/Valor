//
//  PricesAndDiscountsView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

enum LocalizePrices: String {
    case notFound = "Ничего не найдено"
    case fail = "Что-то пошло не так"
    case tryLater = "Попробуйте позднее"
    case update = "Обновить"
}

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

final class PricesAndDiscountsViewModel: ObservableObject {
        private var networkMonitor: INetworkMonitor
        private var localProductManager: ILocalProductManager
        
        init(
            networkMonitor: INetworkMonitor = AppDependencies.shared.networkMonitor,
            localProductManager: ILocalProductManager = AppDependencies.shared.localProductManager
        ) {
            self.networkMonitor = networkMonitor
            self.localProductManager = localProductManager
        }
    }

    // MARK: - Public functions
    extension PricesAndDiscountsViewModel {
        @MainActor
        func loadData(router: Router) async {
            router.push(.pricesAndDiscounts(.loading))
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            let hasInternet = await isInternetAvailable()
            if hasInternet {
                router.push(.productsInternet)
            } else {
                do {
                    let emptyProducts = try localProductManager.productsIsEmpty()
                    if emptyProducts {
                        router.push(.pricesAndDiscounts(.empty))
                    } else {
                        router.push(.productsLocal)
                    }
                } catch {
                    router.push(.pricesAndDiscounts(.error))
                }
            }
        }
    }

    // MARK: - Private functions
    extension PricesAndDiscountsViewModel {
        func productsIsEmpty() -> Bool {
            do {
                return try localProductManager.productsIsEmpty()
            } catch {
                //комментарий
                return false
            }
        }
        
        
        private func isInternetAvailable() async -> Bool {
            await networkMonitor.isInternetAvailable()
        }
    }



struct PricesAndDiscountsView: View {
    @EnvironmentObject var router: Router
    @State var isAnimating: Bool = false
    @StateObject
    private var viewModel = PricesAndDiscountsViewModel()
    var body: some View {
        VStack {
            Color.vlColor.background
                .overlay {
                    VStack {
                        
                        if case let .pricesAndDiscounts(state) = router.currentRoute {
                            switch state {
                            case .error: errorStateView
                            case .loading: loadingStateView
                            case .empty: emptyStateView
                            }
                        }
                        
                    }
                }
        }
        .dynamicTypeSize(.xLarge)
    }
    
    private var loadingStateView: some View {
        LoadingCircleView(isAnimating: $isAnimating)
    }
    
    private var emptyStateView: some View {
        Group {
            if case let .pricesAndDiscounts(state) = router.currentRoute,
               let name = state.imageName {
                Image(name)
            }
            Text(LocalizePrices.notFound.rawValue)
                .font(.titleSFProRegular18())
                .foregroundStyle(Color.vlColor.text)
        }
        .onAppear{
            isAnimating = false
        }
    }
    
    private var errorStateView: some View {
        Group {
            if case let .pricesAndDiscounts(state) = router.currentRoute,
               let name = state.imageName {
                Image(name)
            }
            VStack{
                VStack {
                    Text(LocalizePrices.fail.rawValue)
                        .font(.titleABeeZeeRegular18())
                        .foregroundStyle(Color.vlColor.text)
                        .frame(height: 24)
                    Spacer()
                    Text(LocalizePrices.tryLater.rawValue)
                        .font(.titleABeeZeeRegular18())
                        .foregroundStyle(Color.vlColor.textPrimary)
                }
                .frame(height: 52)
                Spacer()
                Button {
                    Task{
                        await viewModel.loadData(router: router)
                    }
                } label: {
                    HStack {
                        Image(CustomImage.button.rawValue)
                        Text(LocalizePrices.update.rawValue)
                            .tint(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.vlColor.buttons)
                .clipShape(.rect(cornerRadius: 10))
            }
            .frame(height: 108)
        }
        .onAppear{
            isAnimating = false
        }
    }
}



//#Preview {
//    NavigationView(content: {
//        //три состояния экрана PricesAndDiscountsView() - .empty, .error, .loading
//        PricesAndDiscountsView()
//            .navigationTitle(LocalizeRouting.title.rawValue)
//            .navigationBarTitleDisplayMode(.inline)
//            .ignoresSafeArea(edges: .bottom)
//    })
//}
