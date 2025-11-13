//
//  ProductCardView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 12.06.2025.
//

import SwiftUI

/// Main product card view component that combines product information and pricing details.
struct ProductCardView: View {
    let product: Product
    let image: UIImage?
    
    /// Layout constants grouped by logical UI sections for maintainability and scalability.
    private enum Layout {
        enum Card {
            static let height: CGFloat = 240
            static let cornerRadius: CGFloat = 16
        }
        
        enum Image {
            static let width: CGFloat = 84
            static let height: CGFloat = 116
            static let cornerRadius: CGFloat = 8
            static let borderWidth: CGFloat = 2
        }
        
        enum Title {
            static let height: CGFloat = 91
            static let skuTextHeight: CGFloat = 38
            static let verticalSpacing: CGFloat = 3
        }
        
        enum CategoryLabel {
            static let height: CGFloat = 24
            static let cornerRadius: CGFloat = 6
            static let horizontalPadding: CGFloat = 6
        }
        
        enum Menu {
            static let buttonSize: CGFloat = 32
            static let iconSize: CGFloat = 24
            static let cornerRadius: CGFloat = 12
        }
        
        enum Section {
            static let topHeight: CGFloat = 152
            static let bottomHeight: CGFloat = 70
            static let horizontalSpacing: CGFloat = 16
            static let contentPadding: CGFloat = 16
        }
        
    }
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            productInfo
            priceSummary
        }
        .padding(.horizontal)
        .background(Color.vlColor.vlBackground)
        .frame(height: Layout.Card.height)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: Layout.Card.cornerRadius))
    }
    
    /// Top section of the card displaying product image, category, title, SKU, and menu button.
    private var productInfo: some View {
        HStack(alignment: .top, spacing: Layout.Section.horizontalSpacing) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: Layout.Image.width, height: Layout.Image.height)
                    .clipShape(RoundedRectangle(cornerRadius: Layout.Image.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Layout.Image.cornerRadius)
                            .stroke(Color.vlColor.background, lineWidth: Layout.Image.borderWidth)
                    )
            }
            //            RemoteImage(url: product.thumbnail, contentMode: .fit)
            //                .frame(width: Layout.Image.width, height: Layout.Image.height)
            //                .clipShape(RoundedRectangle(cornerRadius: Layout.Image.cornerRadius))
            //                .overlay(
            //                    RoundedRectangle(cornerRadius: Layout.Image.cornerRadius)
            //                        .stroke(Color.vlColor.background, lineWidth: Layout.Image.borderWidth)
            //                )
            VStack(alignment: .leading, spacing: Layout.Title.verticalSpacing) {
                Text(product.category.capitalizingFirstLetter)
                    .categoryLabelStyle()
                Text(product.title)
                    .productTitle()
                VStack(alignment: .leading) {
                    Text(LocalizeProductCard.skuGlobal(product.globalSKU))
                    Text(LocalizeProductCard.skuLocal(product.localSKU))
                }
                .frame(height: Layout.Title.skuTextHeight)
                .font(.titleSFProRegular14())
                .foregroundStyle(Color.vlColor.textPrimary)
                Spacer()
            }
            .frame(height: Layout.Title.height)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                // TODO: Implement menu button action
            } label: {
                Image(CustomImage.burgerPoints.rawValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: Layout.Menu.iconSize, height: Layout.Menu.iconSize)
            }
            .frame(width: Layout.Menu.buttonSize, height: Layout.Menu.buttonSize)
            .background(Color.vlColor.burgerButton)
            .clipShape(RoundedRectangle(cornerRadius: Layout.Menu.cornerRadius))
        }
        .frame(height: Layout.Section.topHeight)
    }
    
    /// Bottom section of the card showing price details, discounts, and final price.
    private var priceSummary: some View {
        VStack {
            PriceSummaryView(
                text: LocalizeProductCard.price,
                priceDetails: product.price,
                currency: product.currency
            )
            PriceSummaryView(
                text: LocalizeProductCard.discounts,
                priceDetails: product.discountPercentage,
                currency: nil
            )
            PriceSummaryView(
                text: LocalizeProductCard.priceWithDiscounts,
                priceDetails: product.discountedPrice,
                currency: product.currency
            )
        }
        .frame(height: Layout.Section.bottomHeight)
        .padding(.bottom)
    }
}

//#Preview {
//    ProductCardView(product: MocData.testProduct)
//        .environment(\.screenWidth, MocData.screenWidth)
//}
