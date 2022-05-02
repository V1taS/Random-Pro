//
//  NumberFormatter.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

extension NumberFormatter {
    
    enum TypeCurrencyFormatter {
        case currency
        case decimal
        
        var formatter: NumberFormatter {
            switch self {
            case .currency: return defaultCurrency
            case .decimal: return defaultDecimal
            }
        }
    }
    
    private class var defaultCurrency: NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.maximumFractionDigits = .zero
        currencyFormatter.minimumFractionDigits = .zero
        currencyFormatter.alwaysShowsDecimalSeparator = false
        currencyFormatter.locale = Locale(identifier: "ru_RU")
        return currencyFormatter
    }
    
    private class var defaultDecimal: NumberFormatter {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.maximumFractionDigits = .zero
        currencyFormatter.minimumFractionDigits = .zero
        currencyFormatter.locale = Locale(identifier: "ru_RU")
        return currencyFormatter
    }
    
    static func `default`(with typeCurrency: TypeCurrencyFormatter) -> NumberFormatter {
        let currencyFormatter = typeCurrency.formatter
        return currencyFormatter
    }
}

extension String {
    static func formatted(with typeCurrency: NumberFormatter.TypeCurrencyFormatter, value: NSNumber) -> String {
        let numberFormatter = NumberFormatter.default(with: typeCurrency)
        guard let formattedString = numberFormatter.string(from: value) else { return "" }
        return formattedString
    }
}
