//
//  TeamInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol TeamInteractor {
    func generateListTeams(state: Binding<AppState.AppData>)
    func createPlayer(state: Binding<AppState.AppData>)
    func generationImageRandom() -> String
    func cleanTeams(state: Binding<AppState.AppData>)
    func saveTeamToUserDefaults(state: Binding<AppState.AppData>)
}

struct TeamInteractorImpl: TeamInteractor {
    
    func generateListTeams(state: Binding<AppState.AppData>) {
        if !state.team.listTempPlayers.wrappedValue.isEmpty {
            shuffledListTeams(state: state)
            takeElementListTeams(state: state)
            switchCurrentTeam(state: state)
        }
    }
    
    func cleanTeams(state: Binding<AppState.AppData>) {
        state.team.listResult1.wrappedValue = []
        state.team.listResult2.wrappedValue = []
        state.team.listResult3.wrappedValue = []
        state.team.listResult4.wrappedValue = []
        state.team.listResult5.wrappedValue = []
        state.team.listResult6.wrappedValue = []
        state.team.listTempPlayers.wrappedValue = state.team.listPlayersData.wrappedValue
        state.team.currentNumber.wrappedValue = 1
        state.team.disabledPickerView.wrappedValue = false
    }
    
    func createPlayer(state: Binding<AppState.AppData>) {
        let image = state.team.playerImageTemp.wrappedValue
        let name = state.team.playerNameTF.wrappedValue
        let player = Player(id: UUID().uuidString, name: name, photo: image)
        state.team.listPlayersData.wrappedValue.append(player)
        state.team.listTempPlayers.wrappedValue.append(player)
    }
    
    func generationImageRandom() -> String {
        let randomNumberPlayers = Int.random(in: 1...15)
        return "player\(randomNumberPlayers)"
    }
    
    func saveTeamToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            savelistResult1(state: state)
            savelistResult2(state: state)
            savelistResult3(state: state)
            savelistResult4(state: state)
            savelistResult5(state: state)
            savelistResult6(state: state)
            savelistPlayersData(state: state)
            savelistTempPlayers(state: state)
            saveCurrentNumber(state: state)
            saveSelectedTeam(state: state)
            saveDisabledPickerView(state: state)
        }
    }
}

extension TeamInteractorImpl {
    private func encoder(players: [Player], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(players) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}


// MARK - Teams Save
extension TeamInteractorImpl {
    private func savelistResult1(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listResult1.wrappedValue,
                forKey: "TeamlistResult1")
    }
    
    private func savelistResult2(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listResult2.wrappedValue,
                forKey: "TeamlistResult2")
    }
    
    private func savelistResult3(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listResult3.wrappedValue,
                forKey: "TeamlistResult3")
    }
    
    private func savelistResult4(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listResult4.wrappedValue,
                forKey: "TeamlistResult4")
    }
    
    private func savelistResult5(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listResult5.wrappedValue,
                forKey: "TeamlistResult5")
    }
    
    private func savelistResult6(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listResult6.wrappedValue,
                forKey: "TeamlistResult6")
    }
    
    private func savelistPlayersData(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listPlayersData.wrappedValue,
                forKey: "TeamlistPlayersData")
    }
    
    private func savelistTempPlayers(state: Binding<AppState.AppData>) {
        encoder(players: state.team
                    .listTempPlayers.wrappedValue,
                forKey: "TeamlistTempPlayers")
    }
    
    private func saveCurrentNumber(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .currentNumber.wrappedValue,
                                  forKey: "TeamCurrentNumber")
    }
    
    private func saveSelectedTeam(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .selectedTeam.wrappedValue,
                                  forKey: "TeamSelectedTeam")
    }
    
    private func saveDisabledPickerView(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .disabledPickerView.wrappedValue,
                                  forKey: "TeamDisabledPickerView")
    }
}

extension TeamInteractorImpl {
    private func switchCurrentTeam(state: Binding<AppState.AppData>) {
        let listResult1 = state.team.listResult1.wrappedValue.count
        let listResult2 = state.team.listResult2.wrappedValue.count
        let listResult3 = state.team.listResult3.wrappedValue.count
        let listResult4 = state.team.listResult4.wrappedValue.count
        let listResult5 = state.team.listResult5.wrappedValue.count
        let listResult6 = state.team.listResult6.wrappedValue.count
        
        let arrResultCount = [listResult1, listResult2, listResult3, listResult4, listResult5, listResult6].sorted()
        let maxCount = arrResultCount.last ?? .zero

        if 1 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult1.wrappedValue.count == .zero {
                state.team.currentNumber.wrappedValue = 1
                return
            }
        }
        
        if 2 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult2.wrappedValue.count == .zero {
                state.team.currentNumber.wrappedValue = 2
                return
            }
        }
        
        if 3 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult3.wrappedValue.count == .zero {
                state.team.currentNumber.wrappedValue = 3
                return
            }
        }
        
        if 4 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult4.wrappedValue.count == .zero {
                state.team.currentNumber.wrappedValue = 4
                return
            }
        }
        
        if 5 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult5.wrappedValue.count == .zero {
                state.team.currentNumber.wrappedValue = 5
                return
            }
        }
        
        if 6 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult6.wrappedValue.count == .zero {
                state.team.currentNumber.wrappedValue = 6
                return
            }
        }
        
        if 1 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult1.wrappedValue.count > .zero && state.team.listResult1.wrappedValue.count < maxCount {
                state.team.currentNumber.wrappedValue = 1
                return
            }
        }
        if 2 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult2.wrappedValue.count > .zero && state.team.listResult2.wrappedValue.count < maxCount {
                state.team.currentNumber.wrappedValue = 2
                return
            }
        }
        if 3 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult3.wrappedValue.count > .zero && state.team.listResult3.wrappedValue.count < maxCount {
                state.team.currentNumber.wrappedValue = 3
                return
            }
        }
        if 4 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult4.wrappedValue.count > .zero && state.team.listResult4.wrappedValue.count < maxCount {
                state.team.currentNumber.wrappedValue = 4
                return
            }
        }
        if 5 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult5.wrappedValue.count > .zero && state.team.listResult5.wrappedValue.count < maxCount {
                state.team.currentNumber.wrappedValue = 5
                return
            }
        }
        if 6 <= state.team.selectedTeam.wrappedValue + 1 {
            if state.team.listResult6.wrappedValue.count > .zero && state.team.listResult6.wrappedValue.count < maxCount {
                state.team.currentNumber.wrappedValue = 6
                return
            }
        }
        
        switch state.team.listTeam.wrappedValue {
        case .listResult1:
            if 1 <= state.team.selectedTeam.wrappedValue + 1 {
                state.team.currentNumber.wrappedValue = 1
                state.team.listTeam.wrappedValue = .listResult2
            }
        case .listResult2:
            if 2 <= state.team.selectedTeam.wrappedValue + 1 {
                state.team.currentNumber.wrappedValue = 2
                state.team.listTeam.wrappedValue = .listResult3
            } else {
                state.team.currentNumber.wrappedValue = 1
                state.team.listTeam.wrappedValue = .listResult1
            }
        case .listResult3:
            if 3 <= state.team.selectedTeam.wrappedValue + 1 {
                state.team.currentNumber.wrappedValue = 3
                state.team.listTeam.wrappedValue = .listResult4
            } else {
                state.team.currentNumber.wrappedValue = 1
                state.team.listTeam.wrappedValue = .listResult1
            }
        case .listResult4:
            if 4 <= state.team.selectedTeam.wrappedValue + 1 {
                state.team.currentNumber.wrappedValue = 4
                state.team.listTeam.wrappedValue = .listResult5
            } else {
                state.team.currentNumber.wrappedValue = 1
                state.team.listTeam.wrappedValue = .listResult1
            }
        case .listResult5:
            if 5 <= state.team.selectedTeam.wrappedValue + 1 {
                state.team.currentNumber.wrappedValue = 5
                state.team.listTeam.wrappedValue = .listResult6
            } else {
                state.team.currentNumber.wrappedValue = 1
                state.team.listTeam.wrappedValue = .listResult1
            }
        case .listResult6:
            if 6 <= state.team.selectedTeam.wrappedValue + 1 {
                state.team.currentNumber.wrappedValue = 6
                state.team.listTeam.wrappedValue = .listResult1
            } else {
                state.team.currentNumber.wrappedValue = 1
                state.team.listTeam.wrappedValue = .listResult1
            }
        }
    }
}

extension TeamInteractorImpl {
    private func shuffledListTeams(state: Binding<AppState.AppData>) {
        state.team.listTempPlayers.wrappedValue.shuffle()
    }
}

extension TeamInteractorImpl {
    private func takeElementListTeams(state: Binding<AppState.AppData>) {
        var newListTempPlayers: [Player] = []
        for player in state.team.listTempPlayers.wrappedValue {
            if player.team == "DNP" {
                continue
            }
            if player.team == "1" {
                state.team.listResult1.wrappedValue.insert(player, at: .zero)
                continue
            }
            if player.team == "2" {
                state.team.listResult2.wrappedValue.insert(player, at: .zero)
                continue
            }
            if player.team == "3" {
                state.team.listResult3.wrappedValue.insert(player, at: .zero)
                continue
            }
            if player.team == "4" {
                state.team.listResult4.wrappedValue.insert(player, at: .zero)
                continue
            }
            if player.team == "5" {
                state.team.listResult5.wrappedValue.insert(player, at: .zero)
                continue
            }
            if player.team == "6" {
                state.team.listResult6.wrappedValue.insert(player, at: .zero)
                continue
            }
            newListTempPlayers.append(player)
        }
        
        state.team.listTempPlayers.wrappedValue = newListTempPlayers
        
        if state.team.listTempPlayers.wrappedValue.count != 0 {
            
            switch state.team.currentNumber.wrappedValue {
            case 1:
                state.team.listResult1.wrappedValue.insert(state.team.listTempPlayers.wrappedValue.first!, at: 0)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 2:
                state.team.listResult2.wrappedValue.insert(state.team.listTempPlayers.wrappedValue.first!, at: 0)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 3:
                state.team.listResult3.wrappedValue.insert(state.team.listTempPlayers.wrappedValue.first!, at: 0)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 4:
                state.team.listResult4.wrappedValue.insert(state.team.listTempPlayers.wrappedValue.first!, at: 0)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 5:
                state.team.listResult5.wrappedValue.insert(state.team.listTempPlayers.wrappedValue.first!, at: 0)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 6:
                state.team.listResult6.wrappedValue.insert(state.team.listTempPlayers.wrappedValue.first!, at: 0)
                state.team.listTempPlayers.wrappedValue.removeFirst()
                
            default: break
            }
        }
    }
}
