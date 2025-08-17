//
//  ProductCardView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 12.06.2025.
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

enum LocalizeProductCard: String {
    case item = "Арт. "
    case price = "Цена продавца до скидки"
    case discounts = "Скидка продавца"
    case priceWithDiscounts = "Цена со скидкой"
}

struct ProductCardView: View {
    let product: Product
    var body: some View {
        VStack(spacing: 0){
            productInfo
            priceSummary
            Spacer()
        }
        .background(Color.vlColor.vlBackground)
        .frame(height: 240)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var productInfo: some View {
        HStack(alignment: .top, spacing: 16){
            RemoteImage(url: product.thumbnail, contentMode: .fit)
                .frame(width: 84, height: 116)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.vlColor.background, lineWidth: 1)
                )
            VStack(alignment: .leading, spacing: 3){
                Text(capitalizeFirstLetter(product.category))
                    .font(.titleSFProRegular14())
                    .foregroundStyle(Color.vlColor.textPrimary)
                    .padding(.horizontal, 6)
                    .background(Color.vlColor.background)
                    .frame(height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                Text(product.title)
                    .font(.titleSFProRegular16())
                    .foregroundStyle(Color.vlColor.text)
                    .truncationMode(.tail)
                VStack(alignment: .leading){
                    Text(
                        LocalizeProductCard.item.rawValue + product.globalSKU
                    )
                    Text(
                        LocalizeProductCard.item.rawValue + product.localSKU
                    )
                }
                .frame(height: 38)
                .font(.titleSFProRegular14())
                .foregroundStyle(Color.vlColor.textPrimary)
                Spacer()
            }
            .frame(height: 91)
            .frame(maxWidth: .infinity, alignment: .leading)
            Button{
                //action
            } label: {
                Image(CustomImage.burgerPoints.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                
            }
            .frame(width: 32, height: 32)
            .background(Color.vlColor.burgerButton)
            .clipShape(.rect(cornerRadius: 12))
        }
        .frame(height: 152)
        .padding(.horizontal)
    }
    
    private var priceSummary: some View {
        VStack{
            PriceSummaryView(
                text: LocalizeProductCard.price.rawValue,
                priceDetails: product.price,
                currency: product.currency
            )
            PriceSummaryView(
                text: LocalizeProductCard.discounts.rawValue,
                priceDetails: product.discountPercentage,
                currency: nil
                
            )
            PriceSummaryView(
                text: LocalizeProductCard.priceWithDiscounts.rawValue, priceDetails: product.discountedPrice,
                currency: product.currency
            )
        }
        .frame(height: 70)
        .padding(.horizontal)
    }
    
    private func capitalizeFirstLetter(_ input: String) -> String {
        guard let first = input.first else { return input }
        return first.uppercased() + input.dropFirst()
    }

}

#Preview {
    ProductCardView(product: MocData.testProduct)
        .environment(\.screenWidth, 375)
}
