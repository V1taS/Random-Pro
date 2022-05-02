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
    func saveYesOrNoToUserDefaults(state: Binding<AppState.AppData>)
}

struct YesOrNoInteractorImpl: YesOrNoInteractor {
    
    func saveYesOrNoToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            saveListResult(state: state)
            saveResult(state: state)
        }
    }
    
    func generateYesOrNo(state: Binding<AppState.AppData>) {
        let randomElement = state.yesOrNo.listYesOrNo.wrappedValue.randomElement()
        state.yesOrNo.listResult.wrappedValue.insert(randomElement!, at: 0)
        state.yesOrNo.result.wrappedValue = randomElement!
    }
    
    func cleanNumber(state: Binding<AppState.AppData>) {
        state.yesOrNo.result.wrappedValue = "?"
        state.yesOrNo.listResult.wrappedValue = []
    }
}

extension YesOrNoInteractorImpl {
    private func saveListResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.yesOrNo
                                    .listResult.wrappedValue,
                                  forKey: "YesOrNoListResult")
    }
    
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.yesOrNo
                                    .result.wrappedValue,
                                  forKey: "YesOrNoResult")
    }
}
