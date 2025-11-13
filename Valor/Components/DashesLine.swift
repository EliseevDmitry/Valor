//
//  DashesLine.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 26.08.2025.
//

import SwiftUI

/// A SwiftUI view displaying a horizontal dashed line with configurable dash count and spacing.
/// Used as a visual separator in the PriceSummaryView component.
/// Dash and gap widths are dynamically calculated based on screen width and padding.
struct DashesLine: View {
    
    private enum Layout {
        static let dashCount: Int = 35
        static let gapRatio: CGFloat = 0.5
        static let sidePadding: CGFloat = 32
        static let lineHeight: CGFloat = 1
        static let cornerRadius: CGFloat = 0.5
    }
    
    private var dashWidth: CGFloat {
        let totalGaps = CGFloat(Layout.dashCount - 1) * Layout.gapRatio
        let totalUnits = CGFloat(Layout.dashCount) + totalGaps
        let availableWidth = ScreenApp.width - Layout.sidePadding
        return availableWidth / totalUnits
    }
    
    private var gapWidth: CGFloat {
        dashWidth * Layout.gapRatio
    }
    
    var body: some View {
        HStack(spacing: gapWidth) {
            ForEach(0..<Layout.dashCount, id: \.self) { _ in
                RoundedRectangle(cornerRadius: Layout.cornerRadius)
                    .frame(width: dashWidth, height: Layout.lineHeight)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    DashesLine()
}
