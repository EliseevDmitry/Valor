//
//  PrimaryButton.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

/// A reusable SwiftUI button component with an optional icon and asynchronous action.
/// Extracted to simplify reuse and facilitate interface scaling as the project grows.
struct PrimaryButton: View {
    let title: String
    let iconName: String?
    let action: () async -> Void

    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 10
        static let cornerRadius: CGFloat = 10
    }

    init(
        title: String,
        iconName: String,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.action = action
    }

    var body: some View {
        Button {
            Task { await action() }
        } label: {
            HStack {
                if let iconName {
                    Image(iconName)
                }
                Text(title)
                    .tint(.white)
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.verticalPadding)
        .background(Color.vlColor.buttons)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cornerRadius))
    }
}

#Preview {
    PrimaryButton(
        title: LocalizePrices.update,
        iconName: CustomImage.button.rawValue,
        action: { print("Tap")}
    )
}
