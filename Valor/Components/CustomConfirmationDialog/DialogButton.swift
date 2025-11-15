//
//  DialogButton.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 15.11.2025.
//

import SwiftUI

struct DialogButton: View {
    @Environment(\.dismiss) var dismiss
    let background: UIColor
    let cornerRadius: CGFloat?
    let corners: UIRectCorner?
    let text: String
    let action: ()
    var body: some View {
        ZStack{
            if
                let cornerRadius = cornerRadius,
                let corners = corners
            {
                Color(background)
                    .cornerRadius(cornerRadius, corners: corners)
            } else {
                Color(background)
            }
            Text(text)
                .font(.body)
                .foregroundStyle(.tint)
        }
        .onTapGesture {
            action
            dismiss()
        }
    }
}

#Preview {
    DialogButton(
        background: .tertiarySystemBackground,
        cornerRadius: 16,
        corners: [.topLeft, .topRight, .bottomLeft, .bottomRight],
        text: "Cancel",
        action:print("1")
    )
}
