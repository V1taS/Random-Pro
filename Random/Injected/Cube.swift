//
//  Cube.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Cube: Equatable {
        var listResult: [String] = []
        var result: String = "?"
        var showSettings = false
        var listImage = ["eagle", "tails"]
    }
}
