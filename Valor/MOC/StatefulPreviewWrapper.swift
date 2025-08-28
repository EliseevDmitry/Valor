//
//  StatefulPreviewWrapper.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 27.08.2025.
//

import SwiftUI

/// A generic SwiftUI wrapper that provides a mutable state value for preview purposes.
/// Allows embedding views requiring a Binding by managing local @State internally.
/// Simplifies testing and previewing views with @Binding properties in Xcode previews.
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
