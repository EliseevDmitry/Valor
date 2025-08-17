//
//  ToastView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.black.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.bottom, 40)
    }
}

#Preview {
    ToastView(message: "Test")
}
