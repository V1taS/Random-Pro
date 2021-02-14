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
    }
    
    func createPlayer(state: Binding<AppState.AppData>) {
        let image = state.team.playerImageTemp.wrappedValue
        let name = state.team.playerNameTF.wrappedValue
        let player = Player(name: name, photo: image)
        state.team.listPlayersData.wrappedValue.append(player)
        state.team.listTempPlayers.wrappedValue.append(player)
    }
    
    func generationImageRandom() -> String {
        let randomNumberPlayers = Int.random(in: 1...15)
        return "player\(randomNumberPlayers)"
    }
    
    func saveTeamToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
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

// MARK - Teams Save
extension TeamInteractorImpl {
    private func savelistResult1(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .listResult1.wrappedValue,
                                  forKey: "TeamlistResult1")
    }
    
    private func savelistResult2(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .listResult2.wrappedValue,
                                  forKey: "TeamlistResult2")
    }
    
    private func savelistResult3(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .listResult3.wrappedValue,
                                  forKey: "TeamlistResult3")
    }
    
    private func savelistResult4(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .listResult4.wrappedValue,
                                  forKey: "TeamlistResult4")
    }
    
    private func savelistResult5(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .listResult5.wrappedValue,
                                  forKey: "TeamlistResult5")
    }
    
    private func savelistResult6(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
                                    .listResult6.wrappedValue,
                                  forKey: "TeamlistResult6")
    }
    
    private func savelistPlayersData(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team.listPlayersData.wrappedValue, forKey: "TeamlistPlayersData")
    }
    
    private func savelistTempPlayers(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.team
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

        for _ in 1..<state.team.selectedTeam.wrappedValue + 1 {
            if state.team.currentNumber.wrappedValue <= state.team.selectedTeam.wrappedValue {
                state.team.currentNumber.wrappedValue += 1
            } else {
                state.team.currentNumber.wrappedValue = 1
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
        if state.team.listTempPlayers.wrappedValue.count != 0 {
            
            switch state.team.currentNumber.wrappedValue {
            case 1:
                state.team.listResult1.wrappedValue.append(state.team.listTempPlayers.wrappedValue.first!)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 2:
                state.team.listResult2.wrappedValue.append(state.team.listTempPlayers.wrappedValue.first!)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 3:
                state.team.listResult3.wrappedValue.append(state.team.listTempPlayers.wrappedValue.first!)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 4:
                state.team.listResult4.wrappedValue.append(state.team.listTempPlayers.wrappedValue.first!)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 5:
                state.team.listResult5.wrappedValue.append(state.team.listTempPlayers.wrappedValue.first!)
                state.team.listTempPlayers.wrappedValue.removeFirst()
            case 6:
                state.team.listResult6.wrappedValue.append(state.team.listTempPlayers.wrappedValue.first!)
                state.team.listTempPlayers.wrappedValue.removeFirst()
         
            default: break
            }
        }
    }
}
