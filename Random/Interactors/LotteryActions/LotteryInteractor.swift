//
//  LotteryInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol LotteryInteractor {
    func generateNumbers(state: Binding<AppState.AppData>)
    func cleanNumbers(state: Binding<AppState.AppData>)
    func saveLotteryToUserDefaults(state: Binding<AppState.AppData>)
}

struct LotteryInteractorImpl: LotteryInteractor {
    
    func saveLotteryToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveResult(state: state)
            savelistResult(state: state)
            saveFirstTF(state: state)
            saveSecondTF(state: state)
        }
    }
    
    func generateNumbers(state: Binding<AppState.AppData>) {
        let firstNumberInt = Int(state.lottery.firstNumber.wrappedValue)
        let secondNumberInt = Int(state.lottery.secondNumber.wrappedValue)
        
        if firstNumberInt! < secondNumberInt! {
            var arrNumbers = [String]()
            var arrRedyNumbers = [String]()
            for number in firstNumberInt!...secondNumberInt! {
                arrNumbers.append(String(number))
            }
            
            arrNumbers.shuffle()
            
            for (index, nomber) in arrNumbers.enumerated() {
                if index + 1 <= firstNumberInt! {
                    arrRedyNumbers.append(nomber)
                }
            }
            
            state.lottery.listResult.wrappedValue = arrRedyNumbers
            state.lottery.result.wrappedValue = arrRedyNumbers.joined(separator: ", ")
        }
    }
    
    func cleanNumbers(state: Binding<AppState.AppData>) {
        state.lottery.result.wrappedValue = "?"
        state.lottery.listResult.wrappedValue = []
    }
}

// MARK - Lottery Save
extension LotteryInteractorImpl {
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.lottery
                                    .result.wrappedValue,
                                  forKey: "LotteryResult")
    }
    
    private func savelistResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.lottery
                                    .listResult.wrappedValue,
                                  forKey: "LotterylistResult")
    }
    
    private func saveFirstTF(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.lottery.firstNumber.wrappedValue,
                                  forKey: "LotteryViewFirstNumber")
    }
    
    private func saveSecondTF(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.lottery.secondNumber.wrappedValue,
                                  forKey: "LotteryViewSecondNumber")
    }
}
