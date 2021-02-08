//
//  YesOrNoInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol YesOrNoInteractor {
    func generateYesOrNo(state: Binding<AppState.AppData>)
    func cleanNumber(state: Binding<AppState.AppData>)
}

struct YesOrNoInteractorImpl: YesOrNoInteractor {
    
    func generateYesOrNo(state: Binding<AppState.AppData>) {
        let randomElement = state.yesOrNo.listYesOrNo.wrappedValue.randomElement()
        state.yesOrNo.listResult.wrappedValue.append(randomElement!)
        state.yesOrNo.result.wrappedValue = randomElement!
    }
    
    func cleanNumber(state: Binding<AppState.AppData>) {
        state.yesOrNo.result.wrappedValue = "?"
        state.yesOrNo.listResult.wrappedValue = []
    }
}
