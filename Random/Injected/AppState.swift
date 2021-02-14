//
//  AppState.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import Combine

struct AppState: Equatable {
    var appData = AppData()
    var system = System()
}

extension AppState {
    struct AppData: Equatable {
        var main = Main()
        var numberRandom = NumberRandom()
        var listWords = ListWords()
        var yesOrNo = YesOrNo()
        var characters = Characters()
        var coin = Coin()
        var cube = Cube()
        var settings = Settings()
        var dateAndTime = DateAndTime()
        var lottery = Lottery()
        var team = Team()
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
    }
}

#if DEBUG
extension AppState {
    static var preview: AppState {
        var state = AppState()
        state.system.isActive = true
        return state
    }
    
    
}
#endif


func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.appData == rhs.appData &&
        lhs.system == rhs.system &&
        lhs.appData.main == rhs.appData.main &&
        lhs.appData.team == rhs.appData.team
}
