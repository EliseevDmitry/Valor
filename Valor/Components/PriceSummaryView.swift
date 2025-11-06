//
//  PriceSummaryView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import SwiftUI

/// A SwiftUI view that displays the product name and total price with a visual dashed line separator.
/// Supports displaying either a formatted price or a percentage value, depending on the provided data.
/// Used in product lists retrieved from the network or local storage.
struct PriceSummaryView: View {
    private enum Layout {
        static let dashOffsetY: CGFloat = -4
    }
    let text: String
    let priceDetails: Double?
    let currency: Currency?
    var body: some View {
        ZStack(alignment: .bottom){
            HStack {
                Text("\(text) ")
                    .font(.titleABeeZeeRegular14())
                    .foregroundStyle(Color.vlColor.titlePriceSummary)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .background(Color.white)
                Spacer()
                Text(formattedPriceText)
                    .font(.titleSFProRegular14())
                    .foregroundStyle(Color.vlColor.textPrimary)
                    .background(Color.vlColor.vlBackground)
            }
            DashesLine()
                .offset(y: Layout.dashOffsetY)
                .zIndex(-1)
                .foregroundStyle(Color.vlColor.dashesLine)
        }
    }
    
    /// Returns a formatted string based on the available data.
    /// Formats the value as a price if a currency is provided; otherwise, as a percentage.
    /// Used for displaying price or discount information in the summary view.
    private var formattedPriceText: String {
        guard let priceDetails = priceDetails else { return "n/a" }
        if let currency {
            return priceDetails.formattedPrice(currencyCode: currency, convertFromBase: true)
        } else {
            return priceDetails.formattedPercentage()
        }
    }
}

#Preview {
    PriceSummaryView(
        text: MocData.testProduct.title,
        priceDetails: MocData.testProduct.price ?? 100,
        currency: MocData.testProduct.currency
    )
    .environment(\.screenWidth, 375)
    .padding(.horizontal)
}
