//
//  СonfirmationDialog.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

/// A SwiftUI component representing the content of a confirmationDialog with buttons for copying SKUs and cancelling.
/// Extracted into a separate component to facilitate future feature expansion and adding new menu items.
struct ConfirmationDialogView: View {
    let copyGlobalSKU: () -> Void
    let copyLocalSKU: () -> Void
    var body: some View {
        Button(LocalizeProducts.copyItem) {
            copyGlobalSKU()
        }
        Button(LocalizeProducts.copyVlItem) {
            copyLocalSKU()
        }
        Button(LocalizeProducts.cancel, role: .cancel) {}
    }
}

#Preview {
    ConfirmationDialogView(copyGlobalSKU: {}, copyLocalSKU: {})
}
