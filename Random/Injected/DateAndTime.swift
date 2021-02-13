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
        
        var noRepetitionsDay = true
        var listDay = [NSLocalizedString("Понедельник", comment: ""),
                       NSLocalizedString("Вторник", comment: ""),
                       NSLocalizedString("Среда", comment: ""),
                       NSLocalizedString("Четверг", comment: ""),
                       NSLocalizedString("Пятница", comment: ""),
                       NSLocalizedString("Суббота", comment: ""),
                       NSLocalizedString("Воскресенье", comment: "")]
        
        var noRepetitionsDate = true
        var listDate = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        
        var noRepetitionsMonth = true
        var listMonth = [NSLocalizedString("Январь", comment: ""),
                         NSLocalizedString("Февраль", comment: ""),
                         NSLocalizedString("Март", comment: ""),
                         NSLocalizedString("Апрель", comment: ""),
                         NSLocalizedString("Май", comment: ""),
                         NSLocalizedString("Июнь", comment: ""),
                         NSLocalizedString("Июль", comment: ""),
                         NSLocalizedString("Август", comment: ""),
                         NSLocalizedString("Сентябрь", comment: ""),
                         NSLocalizedString("Октябрь", comment: ""),
                         NSLocalizedString("Ноябрь", comment: ""),
                         NSLocalizedString("Декабрь", comment: "")]
        
        var showSettings = false
    }
}



