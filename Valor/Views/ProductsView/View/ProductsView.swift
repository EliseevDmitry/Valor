//
//  ProductsView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI
import UIKit

/*
 Требование: "Интерфейс должен маĸсимально точно соответствовать маĸету"
 Использование - magic numbers - плохая практика, старался не прибегать,
 или минимизировать их использование (сложно было понять термин - маĸсимально точно).
 Теоретически можно было - перенести всю геометрию Figma в текущих размерах в уравнения,
 через GR при старте приложения считать wight и height (конкретного устройства)
 и через систему уравнений - пересчитывать интерфейс (максимальное масштабирование под устройство).
 */

struct ProductsView: View {
    @EnvironmentObject var router: Router
    @StateObject private var viewModel: ProductViewModel = ProductViewModel(selectedSegment: .one)
    init(selectedSegment: PickerSegment) {

        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: Color.vlColor.uiBlack, .font: Font.titleSFProRegular], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: Color.vlColor.uiTextPrimary, .font: Font.titleSFProRegular], for: .normal)
    }
    var body: some View {
        /*
         Использую GeometryReader, чтобы передать ширину экрана через EnvironmentValues.
         Это значение потом применяю при отрисовке пунктирной линии.
         Сделано для оптимизации: ширина вычисляется один раз на общий экран.
         */
        GeometryReader{ geometry in
            ScrollView {
                LazyVStack(pinnedViews: [.sectionHeaders]){
                    Section(header: stickyHeader) {bodyProducts}
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
    
    //sticky header UI
    private var stickyHeader: some View {
        ZStack {
            Color.vlColor.vlBackground
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Picker("", selection: $viewModel.selectedSegment) {
                Text(LocalizeProducts.all.rawValue)
                    .tag(PickerSegment.zero)
                
                Text(LocalizeProducts.withoutPrice.rawValue).tag(PickerSegment.one)
            }
            .pickerStyle(.segmented)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.vlColor.burgerButton)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .onChange(of: viewModel.selectedSegment) { newValue in
                switch newValue {
                case PickerSegment.zero: break
                    //routing
                case PickerSegment.one:
//                    router.push(.pricesAndDiscounts(.loading))
//                    Task {
//                        try? await Task.sleep(nanoseconds: 1_000_000_000)
//                        router.push(.pricesAndDiscounts(.empty))
//                    }
                   // router.push(.pricesAndDiscounts(.loading))
                    viewModel.getLocalProducts(router: router)
                }
            }
        }
    }
    
    //scroll products UI
    private var bodyProducts: some View {
        ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, product in
            ProductCardView(product: product)
                .padding(.top, index == 0 ? 5 : 0)
                .onTapGesture {
                    viewModel.selectedProduct = product
                    viewModel.showDialog = true
                }
        }
    }
    
    //confirmationDialog UI
    private var copyIDDialog: some View {
        Group{
//            Button(LocalizeProducts.copyItem.rawValue) {
//                if let id = viewModel.selectedProduct?.id {
//                    viewModel.copyID(id: "\(id)")
//                }
//            }
//            Button(LocalizeProducts.copyVlItem.rawValue) {
//                if let vlId = viewModel.selectedProduct?.vlId {
//                    viewModel.copyID(id: vlId)
//                }
//            }
            Button(LocalizeProducts.cancel.rawValue, role: .cancel) {}
        }
    }
    
    private var toastView: some View {
        Group {
            if viewModel.showToast {
                ToastView(
                    message: LocalizeProducts.copy.rawValue + viewModel.showID()
                )
                .animation(.easeInOut, value: viewModel.showToast)
                .transition(.opacity)
            }
        }
    }
    
}

#Preview {
    NavigationView(content: {
        ProductsView(selectedSegment: PickerSegment.zero)
            .navigationTitle(LocalizeRouting.title.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(edges: .bottom)
            .environmentObject(Router())
    })
}
