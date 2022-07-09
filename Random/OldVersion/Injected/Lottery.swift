//
//  Lottery.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Lottery: Equatable {
        var listResult: [String] = []
        var result: String = "?"
        
        var firstNumber: String = "7"
        var secondNumber: String = "49"
        
        var showSettings = false
    }
}
