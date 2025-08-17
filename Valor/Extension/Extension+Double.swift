//
//  Extension+Double.swift
//  ValorIOS
//
//  Created by Dmitriy Eliseev on 15.06.2025.
//
import Foundation

//статическая конвертация $ <-> ₽ - по фиксированному курсу 79.7
enum LocalizeDouble: String {
    case rub = "₽"
    case usd = "$"
    case rubUsdRate = "79.7"
}

extension Double {
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    func formattedPrice(currencyCode: String, convertFromBase: Bool = false) -> String {
        let formatter = Double.currencyFormatter
        var amount = self
        if convertFromBase {
            switch currencyCode {
            case "RUB":
                amount *= Double(LocalizeDouble.rubUsdRate.rawValue) ?? 0
                formatter.currencySymbol = LocalizeDouble.rub.rawValue
                formatter.positiveFormat = " #,##0 ¤"
            case "USD":
                amount /= Double(LocalizeDouble.rubUsdRate.rawValue) ?? 0
                formatter.currencySymbol = LocalizeDouble.usd.rawValue
                formatter.positiveFormat = "¤#,##0"
            default:
                break
            }
        }
        formatter.currencyCode = currencyCode
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
    func formattedPercentage() -> String {
        return String(format: " %.0f%%", self)
    }
}
