//
//  StatePricesView.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 13.11.2025.
//

import SwiftUI

enum StatePricesView {
    case error, loading, empty
    var imageName: String? {
        switch self {
        case .error:
            CustomImage.errorView.rawValue
        case .empty:
            CustomImage.emptyView.rawValue
        case .loading:
            nil
        }
    }
}
