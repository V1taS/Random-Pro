//
//  NumberInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol NumberInteractor {
    func generateNumber(state: Binding<AppState.AppData>)
    func cleanNumber(state: Binding<AppState.AppData>)
}

struct NumberInteractorImpl: NumberInteractor {
    
    func generateNumber(state: Binding<AppState.AppData>) {
        let randomNum = String(takeRandomNum(state: state))
        switch state.numberRandom.noRepetitions.wrappedValue {
        case true:
            if state.numberRandom.listResult.wrappedValue.contains(randomNum) {
                state.numberRandom.result.wrappedValue = randomNum
                state.numberRandom.listResult.wrappedValue.append(randomNum)
            } else {
                state.numberRandom.result.wrappedValue = randomNum
                state.numberRandom.listResult.wrappedValue.append(randomNum)
            }
        case false:
            state.numberRandom.result.wrappedValue = randomNum
            state.numberRandom.listResult.wrappedValue.append(randomNum)
        }
    }
    
    func cleanNumber(state: Binding<AppState.AppData>) {
        state.numberRandom.result.wrappedValue = "?"
        state.numberRandom.listResult.wrappedValue = []
    }
}

extension NumberInteractorImpl {
    func noRepetitionsInArr(number: [String]) -> Bool {
        Set(number).count == number.count
    }
}

extension NumberInteractorImpl {
    func takeRandomNum(state: Binding<AppState.AppData>) -> UInt {
        var fromNumberInt: UInt = 0
        var toNumberInt: UInt = 0
        
        if let fromNumber = UInt(state.numberRandom.firstNumber.wrappedValue) {
            fromNumberInt = fromNumber
        }
        if let toNumber = UInt(state.numberRandom.secondNumber.wrappedValue) {
            toNumberInt = toNumber
        }
        return UInt.random(in: fromNumberInt...toNumberInt)
    }
    
    func takeRandomNumExcluding(state: Binding<AppState.AppData>, excluding: Int) {

    }
}
