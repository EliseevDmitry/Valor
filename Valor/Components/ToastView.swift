//
//  ToastView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import SwiftUI

/// SwiftUI view for displaying a toast notification.
/// Shows a brief message (in this case, the product's article number when copied to the clipboard).
/// Magic numbers are used directly here for simplicity, as this is an educational project.
/// In a production project, it is recommended to store such constants in a dedicated enum to improve readability and maintainability.
struct ToastView: View {
    let message: String
    var body: some View {
        Text(message)
            .font(.titleSFProRegular16())
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Color
                    .black
                    .opacity(0.7)
            )
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.bottom, 40)
    }
}

#Preview {
    ToastView(message: "Test message")
}
