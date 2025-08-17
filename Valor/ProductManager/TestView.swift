//
//  TestView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 17.08.2025.
//

import SwiftUI

final class TestViewModel: ObservableObject {
//    private(set) var storage: LocalProductManager
//      
//      private init(storage: LocalProductManager) {
//          self.storage = storage
//      }
//      
//      static func create() async throws -> TestViewModel {
//          let storage = try await LocalProductManager.create()
//          return TestViewModel(storage: storage)
//      }
    
}

struct TestView: View {
//    @StateObject private var viewModel = TestViewModel(storage: <#T##LocalProductManager#>)
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TestView()
}
