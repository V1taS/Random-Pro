//
//  RussianLottoInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//


import Combine
import SwiftUI

protocol RussianLottoInteractor {
    func generateKegs(state: Binding<AppState.AppData>)
    func getCurrentKeg(state: Binding<AppState.AppData>)
    func cleanKegs(state: Binding<AppState.AppData>)
    func saveRussianLottoToUserDefaults(state: Binding<AppState.AppData>)
}

struct RussianLottoInteractorImpl: RussianLottoInteractor {
    
    func generateKegs(state: Binding<AppState.AppData>) {
        if state.russianLotto.kegsNumber.wrappedValue.isEmpty {
            var kegs: [Int] = []
            
            for number in 1...90 {
                kegs.append(number)
            }
            state.russianLotto.kegsNumber.wrappedValue = kegs.shuffled()
        }
    }
    
    func getCurrentKeg(state: Binding<AppState.AppData>) {
        guard let keg = state.russianLotto.kegsNumber.wrappedValue.first else { return }
        state.russianLotto.kegsNumber.wrappedValue.removeFirst()
        state.russianLotto.currentKegNumber.wrappedValue = keg
        state.russianLotto.kegsNumberDesk.wrappedValue.append(keg)
    }
    
    func cleanKegs(state: Binding<AppState.AppData>) {
        state.russianLotto.kegsNumber.wrappedValue = []
        state.russianLotto.kegsNumberDesk.wrappedValue = []
        state.russianLotto.currentKegNumber.wrappedValue = 0
    }
    
    func saveRussianLottoToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            saveKegsNumber(state: state)
            saveCurrentKegNumber(state: state)
            saveKegsNumberDesk(state: state)
        }
    }
}

extension RussianLottoInteractorImpl {
    private func saveKegsNumber(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.russianLotto
                                    .kegsNumber.wrappedValue,
                                  forKey: "RussianLottoSaveKegsNumber")
    }
    
    private func saveCurrentKegNumber(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.russianLotto
                                    .currentKegNumber.wrappedValue,
                                  forKey: "RussianLottoSaveCurrentKegNumber")
    }
    
    private func saveKegsNumberDesk(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.russianLotto
                                    .kegsNumberDesk.wrappedValue,
                                  forKey: "RussianLottoSaveKegsNumberDesk")
    }
}
