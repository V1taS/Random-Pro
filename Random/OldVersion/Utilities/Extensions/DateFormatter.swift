//
//  DateFormatter.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension DateFormatter {
    class var onlyDate: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }
}
