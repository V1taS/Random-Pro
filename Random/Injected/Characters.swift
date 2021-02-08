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
        var lang = ["Русские буквы", "Английские буквы"]
        var result: String = "?"
        var selectedLang = 0
        var showSettings = false
        var noRepetitions = false
        var listResult: [String] = []
    }
}
