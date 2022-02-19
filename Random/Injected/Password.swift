//
//  Password.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 18.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Password: Equatable, Decodable {
        var capitalLetters = true
        var numbers = true
        var lowerCase = true
        var symbols = true
        
        var passwordLength = "10"
    }
}
