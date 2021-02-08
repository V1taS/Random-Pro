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

}

struct CharactersInteractorImpl: CharactersInteractor {
    
    func generateNumber(state: Binding<AppState.AppData>) {
        if state.characters.selectedLang.wrappedValue == 0 {
            if takefromNumberInt(state: state) < taketoNumberInt(state: state) {
                switch state.numberRandom.noRepetitions.wrappedValue {
                case true:
                    noRepetitionsNumbers(state: state)
                case false:
                    repetitionsNumbers(state: state)
                }
            }
            
        } else {
            
        }
        
        
        
        
        
    }
    
    func cleanNumber(state: Binding<AppState.AppData>) {
        state.yesOrNo.result.wrappedValue = "?"
        state.yesOrNo.listResult.wrappedValue = []
    }
}

extension CharactersInteractorImpl {
    func takefromNumberInt(state: Binding<AppState.AppData>) -> Int {
        var fromNumberInt: Int = 0
        if let fromNumber = Int(state.numberRandom.firstNumber.wrappedValue) {
            fromNumberInt = fromNumber
        }
        return fromNumberInt
    }
}

extension CharactersInteractorImpl {
    func taketoNumberInt(state: Binding<AppState.AppData>) -> Int {
        var toNumberInt: Int = 0
        if let toNumber = Int(state.numberRandom.secondNumber.wrappedValue) {
            toNumberInt = toNumber
        }
        return toNumberInt
    }
}

extension CharactersInteractorImpl {
    func generateListRandomNumber(from fromNumberInt: Int,
                                  to toNumberInt: Int,
                                  state: Binding<AppState.AppData>) {
        
        for num in fromNumberInt...toNumberInt {
            let numStr = "\(num)"
            state.numberRandom.listRandomNumber.wrappedValue.append(numStr)
        }
    }
}

extension CharactersInteractorImpl {
    func shuffledistRandomNumber(state: Binding<AppState.AppData>) {
        state.numberRandom.listRandomNumber.wrappedValue.shuffle()
    }
}

extension CharactersInteractorImpl {
    func takeNumberFromList(state: Binding<AppState.AppData>) {
        if state.numberRandom.listRandomNumber.wrappedValue.count != 0 {
            state.numberRandom.result.wrappedValue = "\(state.numberRandom.listRandomNumber.wrappedValue.first!)"
            state.numberRandom.listResult.wrappedValue.append("\(state.numberRandom.listRandomNumber.wrappedValue.first!)")
            state.numberRandom.listRandomNumber.wrappedValue.removeFirst()
        }
    }
}

extension CharactersInteractorImpl {
    func noRepetitionsNumbers(state: Binding<AppState.AppData>) {
        if state.numberRandom.result.wrappedValue == "?" {
            generateListRandomNumber(from: takefromNumberInt(state: state),
                                     to: taketoNumberInt(state: state),
                                     state: state)
            shuffledistRandomNumber(state: state)
            takeNumberFromList(state: state)
        } else {
            takeNumberFromList(state: state)
        }
    }
}

extension CharactersInteractorImpl {
    func repetitionsNumbers(state: Binding<AppState.AppData>) {
        let fromNumberInt = takefromNumberInt(state: state)
        let toNumberInt = taketoNumberInt(state: state)
        let randomInt = Int.random(in: fromNumberInt...toNumberInt)
        
        if state.numberRandom.listResult.wrappedValue.count < toNumberInt {
            state.numberRandom.listResult.wrappedValue.append("\(randomInt)")
            state.numberRandom.result.wrappedValue = "\(randomInt)"
        }
    }
}

