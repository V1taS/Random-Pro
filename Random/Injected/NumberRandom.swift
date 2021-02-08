//
//  NumberRandom.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct NumberRandom: Equatable {
        var firstNumber: String = "1"
        var secondNumber: String = "10"
        var result: String = "?"
        var listResult: [String] = []
        var showSettings = false
        var noRepetitions = true
    }
}
