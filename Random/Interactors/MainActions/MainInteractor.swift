//
//  MainInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol MainInteractor {
    func userDefaultsGet(state: Binding<AppState.AppData>)
    func cleanAll(state: Binding<AppState.AppData>)
}

struct MainInteractorImpl: MainInteractor {
    
    func userDefaultsGet(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            userDefaultsGetNumbers(state: state)
            userDefaultsGetYesOrNot(state: state)
            userDefaultsCharacters(state: state)
            userDefaultsListWords(state: state)
            userDefaultsCoin(state: state)
            userDefaultsCube(state: state)
            userDefaultsDate(state: state)
            userDefaultsLottery(state: state)
            userDefaultTeam(state: state)
        }
    }
    
    func cleanAll(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            cleanNumberView()
            cleanYesOrNot()
            cleanCharacters()
            cleanListWords()
            cleanCoin()
            cleanCube()
            cleanDate()
            cleanLottery()
            cleanTeam()
        }
    }
}

extension MainInteractorImpl {
    private func decoder(forKey: String) -> [Player]? {
        if let items = UserDefaults.standard.data(forKey: forKey) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Player].self, from: items) {
                return decoded
            }
        }
        return nil
    }
}

extension MainInteractorImpl {
    private func userDefaultsGetNumbers(state: Binding<AppState.AppData>) {
        if state.numberRandom.listResult.wrappedValue.isEmpty {
            state.numberRandom.listResult.wrappedValue = UserDefaults.standard.array(forKey: "NumberViewListResult") as? [String] ?? []
            state.numberRandom.listRandomNumber.wrappedValue = UserDefaults.standard.array(forKey: "NumberViewListRandomNumber") as? [String] ?? []
            state.numberRandom.noRepetitions.wrappedValue = UserDefaults.standard.bool(forKey: "NumberViewNoRepetitions")
            state.numberRandom.firstNumber.wrappedValue = UserDefaults.standard.object(forKey: "NumberViewFirstNumber") as? String ?? "1"
            state.numberRandom.secondNumber.wrappedValue = UserDefaults.standard.object(forKey: "NumberViewSecondNumber") as? String ?? "10"
            state.numberRandom.result.wrappedValue = UserDefaults.standard.object(forKey: "NumberViewResult") as? String ?? "?"
        }
    }
    
    private func userDefaultsGetYesOrNot(state: Binding<AppState.AppData>) {
        if state.yesOrNo.listResult.wrappedValue.isEmpty {
            state.yesOrNo.listResult.wrappedValue = UserDefaults.standard.array(forKey: "YesOrNoListResult") as? [String] ?? []
            state.yesOrNo.result.wrappedValue = UserDefaults.standard.object(forKey: "YesOrNoResult") as? String ?? "?"
        }
    }
    
    private func userDefaultsCharacters(state: Binding<AppState.AppData>) {
        if state.characters.listResult.wrappedValue.isEmpty {
            state.characters.listResult.wrappedValue = UserDefaults.standard.array(forKey: "CharactersListResult") as? [String] ?? []
            
            state.characters.noRepetitions.wrappedValue = UserDefaults.standard.bool(forKey: "CharactersNoRepetitions")
            
            state.characters.result.wrappedValue = UserDefaults.standard.object(forKey: "CharactersResult") as? String ?? "?"
            
            state.characters.selectedLang.wrappedValue = UserDefaults.standard.object(forKey: "CharactersSelectedLang") as? Int ?? 0
        }
    }
    
    private func userDefaultsListWords(state: Binding<AppState.AppData>) {
        if state.listWords.listResult.wrappedValue.isEmpty {
            
            state.listWords.listResult.wrappedValue = UserDefaults.standard.array(forKey: "ListWordsListResult") as? [String] ?? []
            
            state.listWords.listTemp.wrappedValue = UserDefaults.standard.array(forKey: "ListWordsListTemp") as? [String] ?? []
            
            state.listWords.listData.wrappedValue = UserDefaults.standard.array(forKey: "ListWordsListData") as? [String] ?? []
            
            state.listWords.noRepetitions.wrappedValue = UserDefaults.standard.bool(forKey: "ListWordsNoRepetitions")
            
            state.listWords.result.wrappedValue = UserDefaults.standard.object(forKey: "ListWordsResult") as? String ?? "?"
        }
    }
    
    private func userDefaultsCoin(state: Binding<AppState.AppData>) {
        if state.coin.listResult.wrappedValue.isEmpty {
            
            state.coin.listResult.wrappedValue = UserDefaults.standard.array(forKey: "CoinListResult") as? [String] ?? []
            
            state.coin.resultImage.wrappedValue = UserDefaults.standard.object(forKey: "CoinListResultImage") as? String ?? ""
            
            state.coin.result.wrappedValue = UserDefaults.standard.object(forKey: "CoinResult") as? String ?? "?"
        }
    }
    
    private func userDefaultsCube(state: Binding<AppState.AppData>) {
        if state.cube.listResult.wrappedValue.isEmpty {
            
            state.cube.listResult.wrappedValue = UserDefaults.standard.array(forKey: "CubeListResult") as? [String] ?? []
            
            state.cube.selectedCube.wrappedValue = UserDefaults.standard.object(forKey: "CubeSelectedCube") as? Int ?? 0
            
            state.cube.cubeOne.wrappedValue = UserDefaults.standard.object(forKey: "CubeCubeOne") as? Int ?? 0
            state.cube.cubeTwo.wrappedValue = UserDefaults.standard.object(forKey: "CubeCubeTwo") as? Int ?? 0
            state.cube.cubeThree.wrappedValue = UserDefaults.standard.object(forKey: "CubeCubeThree") as? Int ?? 0
            state.cube.cubeFour.wrappedValue = UserDefaults.standard.object(forKey: "CubeCubeFour") as? Int ?? 0
            state.cube.cubeFive.wrappedValue = UserDefaults.standard.object(forKey: "CubeCubeFive") as? Int ?? 0
            state.cube.cubeSix.wrappedValue = UserDefaults.standard.object(forKey: "CubeCubeSix") as? Int ?? 0
        }
    }
    
    private func userDefaultsDate(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listResult.wrappedValue.isEmpty {
            
            state.dateAndTime.listResult.wrappedValue = UserDefaults.standard.array(forKey: "DateAndTimelistResult") as? [String] ?? []
        
            state.dateAndTime.result.wrappedValue = UserDefaults.standard.object(forKey: "DateAndTimResult") as? String ?? "?"
            
            state.dateAndTime.noRepetitionsDate.wrappedValue = UserDefaults.standard.bool(forKey: "DateAndTimeNoRepetitionsDate")
            
            state.dateAndTime.noRepetitionsDate.wrappedValue = UserDefaults.standard.bool(forKey: "DateAndTimeNoRepetitionsMonth")
            
            state.dateAndTime.noRepetitionsDay.wrappedValue = UserDefaults.standard.bool(forKey: "DateAndTimeNoRepetitionsDay")
        } else {
            state.dateAndTime.listDate.wrappedValue = UserDefaults.standard.array(forKey: "DateAndTimelistDate") as? [String] ?? []
            
            state.dateAndTime.listDay.wrappedValue = UserDefaults.standard.array(forKey: "DateAndTimelistDay") as? [String] ?? []
            
            state.dateAndTime.listMonth.wrappedValue = UserDefaults.standard.array(forKey: "DateAndTimelistMonth") as? [String] ?? []
        }
    }
    
    private func userDefaultsLottery(state: Binding<AppState.AppData>) {
        if state.lottery.listResult.wrappedValue.isEmpty {
            state.lottery.listResult.wrappedValue = UserDefaults.standard.array(forKey: "LotterylistResult") as? [String] ?? []
        
            state.lottery.result.wrappedValue = UserDefaults.standard.object(forKey: "LotteryResult") as? String ?? "?"
            
            state.lottery.firstNumber.wrappedValue = UserDefaults.standard.object(forKey: "LotteryViewFirstNumber") as? String ?? "7"
            state.lottery.secondNumber.wrappedValue = UserDefaults.standard.object(forKey: "LotteryViewSecondNumber") as? String ?? "49"
        }
    }
    
    private func userDefaultTeam(state: Binding<AppState.AppData>) {
        if state.team.listResult1.wrappedValue.isEmpty {
            
            state.team.listResult1.wrappedValue = decoder(forKey: "TeamlistResult1") ?? []
            state.team.listResult2.wrappedValue = decoder(forKey: "TeamlistResult2") ?? []
            state.team.listResult3.wrappedValue = decoder(forKey: "TeamlistResult3") ?? []
            state.team.listResult4.wrappedValue = decoder(forKey: "TeamlistResult4") ?? []
            state.team.listResult5.wrappedValue = decoder(forKey: "TeamlistResult5") ?? []
            state.team.listResult6.wrappedValue = decoder(forKey: "TeamlistResult6") ?? []
            state.team.listPlayersData.wrappedValue = decoder(forKey: "TeamlistPlayersData") ?? []
            state.team.listTempPlayers.wrappedValue = decoder(forKey: "TeamlistTempPlayers") ?? []
            
            state.team.currentNumber.wrappedValue = UserDefaults.standard.object(forKey: "TeamCurrentNumber") as? Int ?? 1
            
            state.team.selectedTeam.wrappedValue = UserDefaults.standard.object(forKey: "TeamSelectedTeam") as? Int ?? 1
            
            state.team.disabledPickerView.wrappedValue = UserDefaults.standard.bool(forKey: "TeamDisabledPickerView")
        }
    }
}

extension MainInteractorImpl {
    private func cleanNumberView() {
        UserDefaults.standard.set([], forKey: "NumberViewListResult")
        UserDefaults.standard.set([], forKey: "NumberViewListRandomNumber")
        UserDefaults.standard.set(true, forKey: "NumberViewNoRepetitions")
        UserDefaults.standard.set("1", forKey: "NumberViewFirstNumber")
        UserDefaults.standard.set("10", forKey: "NumberViewSecondNumber")
        UserDefaults.standard.set("?", forKey: "NumberViewResult")
    }
    
    private func cleanYesOrNot() {
        UserDefaults.standard.set([], forKey: "YesOrNoListResult")
        UserDefaults.standard.set("?", forKey: "YesOrNoResult")
    }
    
    private func cleanCharacters() {
        UserDefaults.standard.set([], forKey: "CharactersListResult")
        UserDefaults.standard.set("?", forKey: "CharactersResult")
        UserDefaults.standard.set(true, forKey: "CharactersNoRepetitions")
        UserDefaults.standard.set(0, forKey: "CharactersSelectedLang")
    }
    
    private func cleanListWords() {
        UserDefaults.standard.set([], forKey: "ListWordsListResult")
        UserDefaults.standard.set([], forKey: "ListWordsListTemp")
        UserDefaults.standard.set([], forKey: "ListWordsListData")
        UserDefaults.standard.set(true, forKey: "ListWordsNoRepetitions")
        UserDefaults.standard.set("?", forKey: "ListWordsResult")
    }
    
    private func cleanCoin() {
        UserDefaults.standard.set([], forKey: "CoinListResult")
        UserDefaults.standard.set("", forKey: "CoinListResultImage")
        UserDefaults.standard.set("?", forKey: "CoinResult")
    }
    
    private func cleanCube() {
        UserDefaults.standard.set([], forKey: "CubeListResult")
        UserDefaults.standard.set(0, forKey: "CubeSelectedCube")
        UserDefaults.standard.set(0, forKey: "CubeCubeOne")
        UserDefaults.standard.set(0, forKey: "CubeCubeTwo")
        UserDefaults.standard.set(0, forKey: "CubeCubeThree")
        UserDefaults.standard.set(0, forKey: "CubeCubeFour")
        UserDefaults.standard.set(0, forKey: "CubeCubeFive")
        UserDefaults.standard.set(0, forKey: "CubeCubeSix")
    }
    
    private func cleanDate() {
        UserDefaults.standard.set([], forKey: "DateAndTimelistResult")
        UserDefaults.standard.set([], forKey: "DateAndTimelistMonth")
        UserDefaults.standard.set([], forKey: "DateAndTimelistDay")
        UserDefaults.standard.set([], forKey: "DateAndTimelistDate")
        UserDefaults.standard.set(true, forKey: "DateAndTimeNoRepetitionsDate")
        UserDefaults.standard.set(true, forKey: "DateAndTimeNoRepetitionsDay")
        UserDefaults.standard.set("?", forKey: "DateAndTimResult")
    }
    
    private func cleanLottery() {
        UserDefaults.standard.set([], forKey: "LotterylistResult")
        UserDefaults.standard.set("?", forKey: "LotteryResult")
    }
    
    private func cleanTeam() {
        UserDefaults.standard.set([], forKey: "TeamlistResult1")
        UserDefaults.standard.set([], forKey: "TeamlistResult2")
        UserDefaults.standard.set([], forKey: "TeamlistResult3")
        UserDefaults.standard.set([], forKey: "TeamlistResult4")
        UserDefaults.standard.set([], forKey: "TeamlistResult5")
        UserDefaults.standard.set([], forKey: "TeamlistResult6")
        UserDefaults.standard.set([], forKey: "TeamlistPlayersData")
        UserDefaults.standard.set([], forKey: "TeamlistTempPlayers")
        
        
        UserDefaults.standard.set(1, forKey: "TeamCurrentNumber")
        UserDefaults.standard.set(1, forKey: "TeamSelectedTeam")
        UserDefaults.standard.set(false, forKey: "TeamDisabledPickerView")
    }
}
