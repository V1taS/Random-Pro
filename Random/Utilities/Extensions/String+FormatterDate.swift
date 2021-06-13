//
//  String+FormatterDate.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

extension String {
    
    func formatterDate() -> String {
        let string = self
        let month = string.dropFirst(5).dropLast(3)
        let day = string.dropFirst(8)

        func findMonth(_ month: String) -> String {
            switch month {
            case "01": return NSLocalizedString("января", comment: "")
            case "02": return NSLocalizedString("февраля", comment: "")
            case "03": return NSLocalizedString("марта", comment: "")
            case "04": return NSLocalizedString("апреля", comment: "")
            case "05": return NSLocalizedString("мая", comment: "")
            case "06": return NSLocalizedString("июня", comment: "")
            case "07": return NSLocalizedString("июля", comment: "")
            case "08": return NSLocalizedString("августа", comment: "")
            case "09": return NSLocalizedString("сентября", comment: "")
            case "10": return NSLocalizedString("октября", comment: "")
            case "11": return NSLocalizedString("ноября", comment: "")
            default: return NSLocalizedString("декабря", comment: "")
            }
        }
        return "\(day) \(findMonth(String(month)))"
    }
}
