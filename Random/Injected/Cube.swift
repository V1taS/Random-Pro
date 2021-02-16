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
    
        var selectedCube = 0
        
        var cubeOne = 0
        var cubeTwo = 0
        var cubeThree = 0
        var cubeFour = 0
        var cubeFive = 0
        var cubeSix = 0
        
        var showSettings = false
    }
}
