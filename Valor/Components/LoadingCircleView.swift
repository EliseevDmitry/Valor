//
//  LoadingLineView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
//

import SwiftUI

/// An animated SwiftUI view showing a semicircle that rotates infinitely.
/// Used as a loading indicator with customizable color, line width, size, and animation duration.
/// Starts the animation when the view appears.
struct LoadingCircleView: View {
    @State private var isAnimating = false
    private enum Layout {
        static let trimFrom: CGFloat = 0
        static let trimTo: CGFloat = 0.5
        static let lineWidth: CGFloat = 5
        static let size: CGFloat = 32
        static let animationDuration: Double = 1
        static let animationRepeatForever = true
        static let animationAutoreverses = false
    }
    var body: some View {
        Circle()
            .trim(from: Layout.trimFrom, to: Layout.trimTo)
            .stroke(Color.vlColor.buttons, lineWidth: Layout.lineWidth)
            .frame(width: Layout.size, height: Layout.size)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: Layout.animationDuration)
                    .repeatForever(autoreverses: Layout.animationAutoreverses),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    LoadingCircleView()
}
