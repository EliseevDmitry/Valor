//
//  СonfirmationDialog.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

/// A SwiftUI component representing the content of a confirmationDialog with buttons for copying SKUs and cancelling.
/// Extracted into a separate component to facilitate future feature expansion and adding new menu items.
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
