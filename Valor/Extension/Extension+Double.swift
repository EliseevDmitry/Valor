//
//  Extension+Double.swift
//  Valor
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//
import Foundation

/// Extension for displaying product prices with multi-currency support.
/// For demonstration purposes, no external service is used for real-time currency rates.
/// To change the currency, simply update the `currency` field in the `Product` model.
/// `currency` is represented as an enum with two cases: `.KZT` and `.USD`.
enum LocalizeDouble: String {
    case kztUsdRate = "538.33"
}

// MARK: - Public functions
extension Double {
    /// Returns a formatted price string according to the specified currency.
    /// - Parameters:
    ///   - currencyCode: the currency to display the price in.
    ///   - convertFromBase: if true, converts from the base currency.
    /// - Returns: a formatted string including the currency symbol.
    func formattedPrice(currencyCode: Currency, convertFromBase: Bool = false) -> String {
        let formatter = Double.currencyFormatter
        var amount = self
        if convertFromBase {
            switch currencyCode {
            case .KZT:
                amount *= Double(LocalizeDouble.kztUsdRate.rawValue) ?? 0
                formatter.currencySymbol = formatter.currencySymbol
                formatter.positiveFormat = " #,##0 ¤"
            case .USD:
                formatter.currencySymbol = formatter.currencySymbol
                formatter.positiveFormat = " #,##0 ¤"
            }
        }
        formatter.currencyCode = currencyCode.rawValue
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    /// Formats a number as a percentage without decimal places.
    /// Example: 0.25 -> "25%"
    func formattedPercentage() -> String {
        return String(format: " %.0f%%", self)
    }
}

// MARK: - Private functions
extension Double {
    /// Shared currency formatter with zero decimal places.
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
}
