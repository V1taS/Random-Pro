//
//  Characters.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Characters: Equatable {
        var lang = [NSLocalizedString("Русские буквы", comment: ""), NSLocalizedString("Английские буквы", comment: "")]
        var result: String = "?"
        
        var showSettings = false
        var noRepetitions = true
        
        var listResult: [String] = []
        
        var selectedLang = 0
        var arrRU = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ь", "Ы", "Ъ", "Э", "Ю", "Я"]
        
        var arrEN = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
}
