//
//  TestView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 17.08.2025.
//

import SwiftUI

final class TestViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    private(set) var storage: ILocalProductManager
     
    init(storage: ILocalProductManager = LocalProductManager()) {
        self.storage = storage
        add()
        update()
    }

    func add() {
        _ = storage.addProduct(MocData.testProduct)
    }
    
    func update(){
        self.products = storage.fechProducts()
    }

    
}

struct TestView: View {
    @StateObject private var viewModel = TestViewModel()
    var body: some View {
        Text(viewModel.products.description)
    }
}

#Preview {
    TestView()
}
