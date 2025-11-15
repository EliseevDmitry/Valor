//
//  ProductsView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI


struct ProductsView: View {
    @EnvironmentObject var router: Router
    @StateObject
    private var viewModel: ProductViewModel = ProductViewModel(selectedSegment: .one)
    var body: some View {
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
        }
        
        .overlay(
            toastView
        )
        .background(Color.vlColor.background)
        .dynamicTypeSize(.xLarge)
        .onAppear{
            viewModel.getProducts()
            //viewModel.delete()
        }
        .sheet(isPresented: $viewModel.showDialog) {
            CustomConfirmationDialog()
                .presentationDetents([.height(ScreenApp.height/5)])
            
        }
        
    }
}



extension ProductsView {
    enum Const {
        static let productTopPadding: CGFloat = 5
        static let dialogCornerRadius: CGFloat = 16
        static let dialogVerticalPadding: CGFloat = 18
    }
    
    // MARK: - Scroll products UI
    
    private var bodyProducts: some View {
        ForEach(
            viewModel.products,
            id: \.id
        ) { product in
            ProductCardView(
                product: product,
                image: viewModel.images[product.id]
            )
            .padding(.top, Const.productTopPadding)
            .onTapGesture {
                viewModel.select(product)
            }
        }
    }
    
    // MARK: - ConfirmationDialog UI
    
    private var copyIDDialog: some View {
        ConfirmationDialogView(
            copyGlobalSKU: {
                viewModel.copyID(id: viewModel.selectedProduct?.globalSKU)
            },
            copyLocalSKU: {
                viewModel.copyID(id: viewModel.selectedProduct?.localSKU)
            }
        )
    }
    
    // MARK: - Toast
    
    @ViewBuilder
    private var toastView: some View {
        if viewModel.showToast {
            ToastView(
                showToast: $viewModel.showToast,
                sku: viewModel.showID()
            )
        }
    }
    
    //    @ViewBuilder
    //    private var confirmationDialog: some View {
    //        if #available(iOS 18.0, *) {
    //
    //                .sheet(isPresented: $viewModel.showDialog) {
    //                    CustomConfirmationDialog()
    //                        .presentationDetents([.height(ScreenApp.height/5)])
    //                }
    //
    //        } else {
    //            .confirmationDialog("", isPresented: $viewModel.showDialog, titleVisibility: .hidden) {
    //                copyIDDialog
    //            }
    //        }
    //    }
    
    
    
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
