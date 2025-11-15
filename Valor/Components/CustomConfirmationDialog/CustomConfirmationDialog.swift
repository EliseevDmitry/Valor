//
//  CustomConfirmationDialog.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 15.11.2025.
//

import SwiftUI

struct CustomConfirmationDialog: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 0) {
            DialogButton(
                background: .secondarySystemBackground,
                cornerRadius: nil,
                corners: nil,
                text: LocalizeProducts.copyItem,
                action:print("1")
            )
            Divider()
            DialogButton(
                background: .secondarySystemBackground,
                cornerRadius: 16,
                corners: [.bottomLeft, .bottomRight],
                text: LocalizeProducts.copyVlItem,
                action:print("1")
            )
            .padding(.bottom, 8)
            DialogButton(
                background: .tertiarySystemBackground,
                cornerRadius: 16,
                corners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
                text: "Cancel",
                action:print("1")
            )
        }
    }
}

#Preview {
    CustomConfirmationDialog()
}
