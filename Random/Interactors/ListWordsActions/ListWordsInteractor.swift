//
//  ListWordsInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol ListWordsInteractor {
    func generateWords(state: Binding<AppState.AppData>)
    func cleanWords(state: Binding<AppState.AppData>)
    func saveListWordsToUserDefaults(state: Binding<AppState.AppData>)
}

struct ListWordsInteractorImpl: ListWordsInteractor {
    
    func saveListWordsToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveListResult(state: state)
            saveListTemp(state: state)
            saveListData(state: state)
            saveNoRepetitions(state: state)
            saveResult(state: state)
        }
    }
    
    func generateWords(state: Binding<AppState.AppData>) {
        switch state.listWords.noRepetitions.wrappedValue {
        case true:
            noRepetitionsWords(state: state)
        case false:
            repetitionsWords(state: state)
        }
    }
    
    func cleanWords(state: Binding<AppState.AppData>) {
        state.listWords.result.wrappedValue = "?"
        state.listWords.listResult.wrappedValue = []
        state.listWords.listTemp.wrappedValue = state.listWords.listData.wrappedValue
        
    }
}

extension ListWordsInteractorImpl {
    private func noRepetitionsWords(state: Binding<AppState.AppData>) {
        shuffledistRandomWords(state: state)
        takeElementWordsFromList(state: state)
    }
}

extension ListWordsInteractorImpl {
    private func shuffledistRandomWords(state: Binding<AppState.AppData>) {
        state.listWords.listTemp.wrappedValue.shuffle()
    }
}

extension ListWordsInteractorImpl {
    private func takeElementWordsFromList(state: Binding<AppState.AppData>) {
        if state.listWords.listTemp.wrappedValue.count != 0 {
            state.listWords.result.wrappedValue = "\(state.listWords.listTemp.wrappedValue.first!)"
            state.listWords.listResult.wrappedValue.append("\(state.listWords.listTemp.wrappedValue.first!)")
            state.listWords.listTemp.wrappedValue.removeFirst()
        }
    }
}

extension ListWordsInteractorImpl {
    private func repetitionsWords(state: Binding<AppState.AppData>) {
        if state.listWords.listResult.wrappedValue.count < state.listWords.listTemp.wrappedValue.count {
            let randomInt = state.listWords.listTemp.wrappedValue.randomElement()
            state.listWords.listResult.wrappedValue.append("\(randomInt ?? "")")
            state.listWords.result.wrappedValue = "\(randomInt ?? "")"
        }
    }
}

extension ListWordsInteractorImpl {
    private func saveListResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.listWords
                                    .listResult.wrappedValue,
                                  forKey: "ListWordsListResult")
    }
    
    private func saveListTemp(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.listWords
                                    .listTemp.wrappedValue,
                                  forKey: "ListWordsListTemp")
    }
    
    private func saveListData(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.listWords
                                    .listData.wrappedValue,
                                  forKey: "ListWordsListData")
    }
    
    private func saveNoRepetitions(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.listWords
                                    .noRepetitions.wrappedValue,
                                  forKey: "ListWordsNoRepetitions")
    }
    
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.listWords
                                    .result.wrappedValue,
                                  forKey: "ListWordsResult")
    }
    
    
}
