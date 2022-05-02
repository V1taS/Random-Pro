//
//  MusicSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 18.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct MusicSettingsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Text(NSLocalizedString("Музыки сгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.music.listMusicHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: MusicHistoryView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("История", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanMusic(state: appBinding)
                            appBinding.music.showSettings.wrappedValue = false
                            saveFilmsToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                                .font(.robotoRegular16())
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.music.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

private extension MusicSettingsView {
    private func cleanMusic(state: Binding<AppState.AppData>) {
        injected.interactors.musicInteractor
            .cleanMusic(state: state)
    }
    
    private func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.musicInteractor
            .saveFilmsToUserDefaults(state: state)
    }
}

struct MusicSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MusicSettingsView(appBinding: .constant(.init()))
    }
}
