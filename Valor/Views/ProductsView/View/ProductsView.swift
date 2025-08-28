//
//  ProductsView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject
    var router: Router
    @StateObject
    private var viewModel: ProductViewModel = ProductViewModel(selectedSegment: .one)
    var body: some View {
        GeometryReader{ geometry in
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]){
                    Section(header: StickyHeader(
                        selectedSegment: $viewModel.selectedSegment
                    ) { newSegment in
                        viewModel.segmentChanged(
                            to: newSegment,
                            router: router
                        )
                    }) {
                        bodyProducts
                    }
                }
                .confirmationDialog("", isPresented: $viewModel.showDialog, titleVisibility: .hidden) {copyIDDialog}
            }
            .environment(\.screenWidth, geometry.size.width)
            .overlay(
                toastView
            )
        }
        .background(Color.vlColor.background)
        .dynamicTypeSize(.xLarge)
        .onAppear{
            viewModel.getProducts()
        }
    }
    
    //scroll products UI
    private var bodyProducts: some View {
        ForEach(
            viewModel.products,
            id: \.id
        ) {product in
            ProductCardView(product: product)
                .padding(.top, 5)
                .onTapGesture {
                    viewModel.select(product)
                }
        }
    }
    
    //confirmationDialog UI
    private var copyIDDialog: some View {
        СonfirmationDialogView(
            copyGlobalSKU: {
                viewModel.copyID(id: viewModel.selectedProduct?.globalSKU)
            },
            copyLocalSKU: {
                viewModel.copyID(id: viewModel.selectedProduct?.localSKU)
            }
        )
    }
    
    //отображения сообщения о скопированных данных
    private var toastView: some View {
        Group {
            if viewModel.showToast {
                ToastView(
                    showToast: $viewModel.showToast,
                    sku: viewModel.showID()
                )
            }
        }
    } 
}

#Preview {
    NavigationView(content: {
        ProductsView()
            .navigationTitle(LocalizeRouting.title)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .environmentObject(Router())
    })
}
