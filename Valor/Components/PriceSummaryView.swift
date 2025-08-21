//
//  PriceSummaryView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 14.06.2025.
//

import SwiftUI

/*
 Требование: "Интерфейс должен маĸсимально точно соответствовать маĸету"
 Использование - magic numbers - плохая практика, старался не прибегать,
 или минимизировать их использование (сложно было понять термин - маĸсимально точно).
 Теоретически можно было - перенести всю геометрию Figma в текущих размерах в уравнения,
 через GR при старте приложения считать wight и height (конкретного устройства)
 и через систему уравнений - пересчитывать интерфейс (максимальное масштабирование под устройство).
 */

struct PriceSummaryView: View {
    let text: String
    let priceDetails: Double
    let currency: Currency?
    var body: some View {
        ZStack(alignment: .bottom){
            HStack {
                Text("\(text) ")
                    .font(.titleABeeZeeRegular14())
                    .foregroundStyle(Color.vlColor.titlePriceSummary)
                    .background(Color.white)
                Spacer()
                Text(formattedPriceText)
                    .font(.titleSFProRegular14())
                    .foregroundStyle(Color.vlColor.textPrimary)
                    .background(Color.vlColor.vlBackground)
            }
            DashesLine()
                .offset(CGSize(width: 0, height: -4))
                .zIndex(-1)
                .foregroundStyle(Color.vlColor.dashesLine)
        }
    }
    
    private var formattedPriceText: String {
        if let currency {
            return priceDetails.formattedPrice(currencyCode: currency, convertFromBase: true)
        } else {
            return priceDetails.formattedPercentage()
        }
    }
}

struct DashesLine: View {
    @Environment(\.screenWidth) private var screenWidth
    let dashCount = 35
    let gapCount = 34
    let lineHeight: CGFloat = 1
    let cornerRadius: CGFloat = 0.5
    var body: some View {
        let dashWidth = (screenWidth - 32) / (CGFloat(dashCount) + CGFloat(gapCount) / 2)
        let gapWidth = dashWidth / 2
        HStack(spacing: gapWidth) {
            ForEach(0..<dashCount, id: \.self) { _ in
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: dashWidth, height: lineHeight)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PriceSummaryView(
        text: MocData.testProduct.title,
        priceDetails: MocData.testProduct.price,
        currency: MocData.testProduct.currency
    )
    .environment(\.screenWidth, 375)
    .padding(.horizontal)
}
