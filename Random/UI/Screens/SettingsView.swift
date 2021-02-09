//
//  SettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("ОСНОВНЫЕ")) {
                        HStack {
                            Spacer()
                            Button(action: {
                                cleanApp(state: appBinding)
                            }) {
                                Text("Очистить кэш")
                                    .foregroundColor(.primaryError())
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .automatic)
        }
    }
}

// MARK: Actions
private extension SettingsView {
    private func cleanApp(state: Binding<AppState.AppData>) {
        injected.interactors.numberInteractor
            .cleanNumber(state: state)
        
        injected.interactors.yesOrNoInteractor
            .cleanNumber(state: state)
        
        injected.interactors.charactersInteractor
            .cleanCharacters(state: state)
        
        injected.interactors.listWordsInteractor
            .cleanWords(state: state)
        
        injected.interactors.coinInteractor
            .cleanCoins(state: state)
        
        injected.interactors.cubeInterator
            .cleanCube(state: state)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(appBinding: .constant(.init()))
    }
}
