//
//  PrimaryButton.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let iconName: String?
    let action: () async -> Void
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
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.vlColor.buttons)
        .clipShape(.rect(cornerRadius: 10))
    }
}

#Preview {
    PrimaryButton(
        title: LocalizePrices.update.rawValue,
        iconName: CustomImage.button.rawValue,
        action: { print("Tap")}
    )
}
