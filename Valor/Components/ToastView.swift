//
//  ToastView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import SwiftUI

/// SwiftUI view for displaying a toast notification.
/// Shows a brief message (in this case, the product's article number when copied to the clipboard).
struct ToastView: View {
    @Binding var showToast: Bool
    let sku: String
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 12
        static let bottomPadding: CGFloat = 40
        static let backgroundOpacity: Double = 0.7
        static let animation: Animation = .easeInOut
    }
    
    var body: some View {
        Text(LocalizeProducts.copy(sku))
            .font(.titleSFProRegular16())
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(
                Color.black.opacity(Layout.backgroundOpacity)
            )
            .foregroundColor(.white)
            .cornerRadius(Layout.cornerRadius)
            .padding(.bottom, Layout.bottomPadding)
            .animation(Layout.animation, value: showToast)
            .transition(.opacity)
    }
}

#Preview {
    StatefulPreviewWrapper(true) { binding in
        ToastView(showToast: binding, sku: "Test message")
    }
}
