//
//  Extension+View.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 15.11.2025.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}
