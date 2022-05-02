//
//  CoinInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol CoinInteractor {
    func generateCoins(state: Binding<AppState.AppData>)
    func cleanCoins(state: Binding<AppState.AppData>)
    func saveCoinIToUserDefaults(state: Binding<AppState.AppData>)
}

struct CoinInteractorImpl: CoinInteractor {
    
    func saveCoinIToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            saveListResult(state: state)
            saveListResultImage(state: state)
            saveResult(state: state)
        }
    }
    
    func generateCoins(state: Binding<AppState.AppData>) {
        shuffledistRandomCoins(state: state)
    }
    
    func cleanCoins(state: Binding<AppState.AppData>) {
        state.coin.result.wrappedValue = "?"
        state.coin.resultImage.wrappedValue = ""
        state.coin.listResult.wrappedValue = []
    }
}

extension CoinInteractorImpl {
    private func shuffledistRandomCoins(state: Binding<AppState.AppData>) {
        let randomCoin = Int.random(in: 0...1)
        state.coin.result.wrappedValue = state.coin.listName.wrappedValue[randomCoin]
        state.coin.listResult.wrappedValue.insert(state.coin.listName.wrappedValue[randomCoin], at: 0)
        state.coin.resultImage.wrappedValue = state.coin.listImage.wrappedValue[randomCoin]
    }
}

extension CoinInteractorImpl {
    private func saveListResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.coin
                                    .listResult.wrappedValue,
                                  forKey: "CoinListResult")
    }
    
    private func saveListResultImage(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.coin
                                    .resultImage.wrappedValue,
                                  forKey: "CoinListResultImage")
    }
    
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.coin
                                    .result.wrappedValue,
                                  forKey: "CoinResult")
    }
}
