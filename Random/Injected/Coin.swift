//
//  Coin.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Coin: Equatable {
        var listResult: [String] = []
        var result: String = "?"
        var resultImage: String = ""
        var showSettings = false
        var listImage = ["eagle", "tails"]
        var listName = [NSLocalizedString("Орел", comment: ""), NSLocalizedString("Решка", comment: "")]
    }
}
