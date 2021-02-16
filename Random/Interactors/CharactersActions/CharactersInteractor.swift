//
//  YesOrNoInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol CharactersInteractor {
    func generateCharacters(state: Binding<AppState.AppData>)
    func cleanCharacters(state: Binding<AppState.AppData>)
    func saveCharactersToUserDefaults(state: Binding<AppState.AppData>)
}

struct CharactersInteractorImpl: CharactersInteractor {
    
    func saveCharactersToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveListResult(state: state)
            saveNoRepetitions(state: state)
            saveResult(state: state)
            saveSelectedLang(state: state)
        }
    }
    
    func generateCharacters(state: Binding<AppState.AppData>) {
        if state.characters.selectedLang.wrappedValue == 0 {
            switch state.numberRandom.noRepetitions.wrappedValue {
            case true:
                noRepetitionsArrRU(state: state)
            case false:
                repetitionsArrRU(state: state)
            }
        }
        else {
            switch state.numberRandom.noRepetitions.wrappedValue {
            case true:
                noRepetitionsArrEN(state: state)
            case false:
                repetitionsArrEN(state: state)
            }
        }
    }
    
    func cleanCharacters(state: Binding<AppState.AppData>) {
        state.characters.result.wrappedValue = "?"
        state.characters.listResult.wrappedValue = []
        state.characters.arrRU.wrappedValue = ["А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ь", "Ы", "Ъ", "Э", "Ю", "Я"]
        state.characters.arrEN.wrappedValue = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
}

extension CharactersInteractorImpl {
    private func shuffledistRandomArrRU(state: Binding<AppState.AppData>) {
        state.characters.arrRU.wrappedValue.shuffle()
    }
}

extension CharactersInteractorImpl {
    private func shuffledistRandomArrEN(state: Binding<AppState.AppData>) {
        state.characters.arrEN.wrappedValue.shuffle()
    }
}

extension CharactersInteractorImpl {
    private func takeElementRuFromList(state: Binding<AppState.AppData>) {
        if state.characters.arrRU.wrappedValue.count != 0 {
            state.characters.result.wrappedValue = "\(state.characters.arrRU.wrappedValue.first!)"
            state.characters.listResult.wrappedValue.insert("\(state.characters.arrRU.wrappedValue.first!)", at: 0)
            state.characters.arrRU.wrappedValue.removeFirst()
        }
    }
}

extension CharactersInteractorImpl {
    private func takeElementEnFromList(state: Binding<AppState.AppData>) {
        if state.characters.arrEN.wrappedValue.count != 0 {
            state.characters.result.wrappedValue = "\(state.characters.arrEN.wrappedValue.first!)"
            state.characters.listResult.wrappedValue.insert("\(state.characters.arrEN.wrappedValue.first!)", at: 0)
            state.characters.arrEN.wrappedValue.removeFirst()
        }
    }
}

extension CharactersInteractorImpl {
    private func noRepetitionsArrRU(state: Binding<AppState.AppData>) {
        shuffledistRandomArrRU(state: state)
        takeElementRuFromList(state: state)
    }
}


extension CharactersInteractorImpl {
    private func noRepetitionsArrEN(state: Binding<AppState.AppData>) {
        shuffledistRandomArrEN(state: state)
        takeElementEnFromList(state: state)
    }
}

extension CharactersInteractorImpl {
    private func repetitionsArrRU(state: Binding<AppState.AppData>) {
        if state.characters.listResult.wrappedValue.count < state.characters.arrRU.wrappedValue.count {
            let randomInt = state.characters.arrRU.wrappedValue.randomElement()
            state.characters.listResult.wrappedValue.insert("\(randomInt ?? "")", at: 0)
            state.characters.result.wrappedValue = "\(randomInt ?? "")"
        }
    }
}

extension CharactersInteractorImpl {
    private func repetitionsArrEN(state: Binding<AppState.AppData>) {
        if state.characters.listResult.wrappedValue.count < state.characters.arrEN.wrappedValue.count {
            let randomInt = state.characters.arrEN.wrappedValue.randomElement()
            state.characters.listResult.wrappedValue.insert("\(randomInt ?? "")", at: 0)
            state.characters.result.wrappedValue = "\(randomInt ?? "")"
        }
    }
}

extension CharactersInteractorImpl {
    private func saveListResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .listResult.wrappedValue,
                                  forKey: "CharactersListResult")
    }
    
    private func saveNoRepetitions(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .noRepetitions.wrappedValue,
                                  forKey: "CharactersNoRepetitions")
    }
    
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .result.wrappedValue,
                                  forKey: "CharactersResult")
    }
    
    private func saveSelectedLang(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .selectedLang.wrappedValue,
                                  forKey: "CharactersSelectedLang")
    }
}
