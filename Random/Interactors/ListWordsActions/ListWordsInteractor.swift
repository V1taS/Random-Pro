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
}

struct ListWordsInteractorImpl: ListWordsInteractor {
    
    func generateWords(state: Binding<AppState.AppData>) {
        copyDataTemp(state: state)
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
        state.listWords.listTemp.wrappedValue = []
        state.listWords.copyDataTemp.wrappedValue = .empty
        
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
    private func copyDataTemp(state: Binding<AppState.AppData>) {
        if state.listWords.copyDataTemp.wrappedValue == .empty {
            state.listWords.listTemp.wrappedValue = state.listWords.listData.wrappedValue
            state.listWords.copyDataTemp.wrappedValue = .full
        }
    }
}
