//
//  RussianLotto.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

extension AppState.AppData {
    struct RussianLotto: Equatable, Decodable {
        var kegsNumber: [Int] = []
        var currentKegNumber = 0
        var kegsNumberDesk: [Int] = []
    }
}
