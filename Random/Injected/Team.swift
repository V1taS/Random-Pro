//
//  Team.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Team: Equatable, Decodable {
        var listTeam: ListTeam = .listResult1
        
        var listResult1: [Player] = []
        var listResult2: [Player] = []
        var listResult3: [Player] = []
        var listResult4: [Player] = []
        var listResult5: [Player] = []
        var listResult6: [Player] = []
        var currentNumber = 1
        
        var listPlayersData: [Player] = []
        
        var listTempPlayers: [Player] = []
        var playerImageTemp = "player15"
        
        var selectedTeam = 1
        
        var playerNameTF = ""
        
        var showSettings = false
        var showAddPlayer = false
        var disabledPickerView = false
    }
}
extension AppState.AppData {
    enum ListTeam: Equatable, Decodable {
        case listResult1
        case listResult2
        case listResult3
        case listResult4
        case listResult5
        case listResult6
    }
}

