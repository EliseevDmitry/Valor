//
//  StickyHeader.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 22.08.2025.
//

import SwiftUI


struct StickyHeader: View {
    @Binding var selectedSegment: PickerSegment
    let action: (PickerSegment) -> Void
    init(
        selectedSegment: Binding<PickerSegment>,
        action: @escaping (PickerSegment) -> Void
    ) {
            self._selectedSegment = selectedSegment
            self.action = action
            UISegmentedControl.applyCustomStyle()
        }
    var body: some View {
        VStack {
            Picker("", selection: $selectedSegment) {
                Text(LocalizeProducts.all.rawValue)
                    .tag(PickerSegment.zero)
                
                Text(LocalizeProducts.withoutPrice.rawValue)
                    .tag(PickerSegment.one)
            }
            .pickerStyle(.segmented)
            .padding(10)
            .background(.white)
            .onChange(of: selectedSegment) { newValue in
                action(newValue)
            }
        }
    }
}

#Preview {
    StickyHeader(
        selectedSegment: .constant(.zero),
        action: { _ in }
    )
    .environmentObject(Router())
}
