//
//  Extension+String.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 27.08.2025.
//

import Foundation

/// Returns a copy of the string with only the first character capitalized,
/// leaving the rest of the string unchanged.
extension String {
    var capitalizingFirstLetter: String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst()
    }
}
