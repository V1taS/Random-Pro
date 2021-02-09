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
}

struct CoinInteractorImpl: CoinInteractor {
    
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
        state.coin.listResult.wrappedValue.append(state.coin.listName.wrappedValue[randomCoin])
        state.coin.resultImage.wrappedValue = state.coin.listImage.wrappedValue[randomCoin]
    }
}
