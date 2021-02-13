//
//  DateAndTime.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct DateAndTime: Equatable {
        var listResult: [String] = []
        var result: String = "?"
        
        var listDay = [NSLocalizedString("Понедельник", comment: ""),
                       NSLocalizedString("Вторник", comment: ""),
                       NSLocalizedString("Среда", comment: ""),
                       NSLocalizedString("Четверг", comment: ""),
                       NSLocalizedString("Пятница", comment: ""),
                       NSLocalizedString("Суббота", comment: ""),
                       NSLocalizedString("Воскресенье", comment: "")]
        var noRepetitionsDay = true
        
        
        
        var showSettings = false
    }
}


