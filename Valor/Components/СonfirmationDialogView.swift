//
//  СonfirmationDialog.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

struct СonfirmationDialogView: View {
    let copyGlobalSKU: () -> Void
    let copyLocalSKU: () -> Void
    var body: some View {
        Button(LocalizeProducts.copyItem.rawValue) {
            copyGlobalSKU()
        }
        Button(LocalizeProducts.copyVlItem.rawValue) {
            copyLocalSKU()
        }
        Button(LocalizeProducts.cancel.rawValue, role: .cancel) {}
    }
}

#Preview {
    СonfirmationDialogView(copyGlobalSKU: {}, copyLocalSKU: {})
}
