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
        userDefaultsGetNumbers(state: state)
        userDefaultsGetYesOrNot(state: state)
        userDefaultsCharacters(state: state)
        userDefaultsListWords(state: state)
    }
    
    func cleanAll(state: Binding<AppState.AppData>) {
        cleanNumberView()
        cleanYesOrNot()
        cleanCharacters()
        cleanListWords()
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
}
