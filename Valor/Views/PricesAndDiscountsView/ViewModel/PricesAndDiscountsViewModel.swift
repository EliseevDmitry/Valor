//
//  PricesAndDiscountsViewModel.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import Foundation

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
