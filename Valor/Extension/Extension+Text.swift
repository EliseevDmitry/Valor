//
//  Extension+Text.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 27.08.2025.
//

import SwiftUI

extension Text {
    func categoryLabelStyle() -> some View {
        self
            .font(.titleSFProRegular14())
            .foregroundStyle(Color.vlColor.textPrimary)
            .padding(.horizontal, 6)
            .background(Color.vlColor.background)
            .frame(height: 24)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    func productTitle() -> some View {
        self
            .font(.titleSFProRegular16())
            .foregroundStyle(Color.vlColor.text)
            .truncationMode(.tail)
    }
}
