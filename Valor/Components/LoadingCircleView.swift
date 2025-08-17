//
//  LoadingLineView.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 11.06.2025.
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

struct LoadingCircleView: View {
    @Binding var isAnimating: Bool
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .stroke(Color.vlColor.buttons, lineWidth: 5)
            .frame(width: 32, height: 32)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                Animation.linear(duration: 1)
                    .repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

#Preview {
    LoadingCircleView(isAnimating: .constant(true))
}
