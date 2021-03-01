//
//  FilmSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 01.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import AVKit

struct FilmSettingsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    if !appBinding.film.filmsHistory.wrappedValue.isEmpty {
                        HStack {
                            NavigationLink(
                                destination: FilmInformationView(filmsInfo: appBinding.film.filmInfo.wrappedValue,
                                                                 iframeSrc: (appBinding.film.filmsVideoHistory.wrappedValue.last?.iframeSrc)!)
                                    .allowAutoDismiss { false }) {
                                Text(NSLocalizedString("Информация по фильму", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                            }
                            Spacer()
                        }
                        
                        HStack {
                            NavigationLink(
                                destination: FilmHistoryView(appBinding: appBinding)
                                    .allowAutoDismiss { false }) {
                                Text(NSLocalizedString("История генерации", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                            }
                            Spacer()
                        }
                        
                        HStack {
                            Text(NSLocalizedString("Последний фильм", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                            
                            Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmInfo.data.wrappedValue?.nameRu ?? "нет")" : "\(appBinding.film.filmInfo.data.wrappedValue?.nameEn ?? "нет")")
                                .gradientForeground(colors: [Color.primaryGreen(), Color.primaryTertiary()])
                                .font(.robotoMedium18())
                        }
                        
                        HStack {
                            Text(NSLocalizedString("Всего сгенерировано", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                            
                            Text("\(appBinding.film.filmsHistory.wrappedValue.count)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                cleanContacts(state: appBinding)
                                saveContactToUserDefaults(state: appBinding)
                                Feedback.shared.impactHeavy(.medium)
                            }) {
                                Text(NSLocalizedString("Очистить", comment: ""))
                                    .font(.robotoRegular16())
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.film.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions
private extension FilmSettingsView {
    private func cleanContacts(state: Binding<AppState.AppData>) {
        injected.interactors.contactInteractor
            .cleanContacts(state: state)
    }
}

private extension FilmSettingsView {
    private func saveContactToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.contactInteractor
            .saveContactToUserDefaults(state: state)
    }
}

struct FilmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FilmSettingsView(appBinding: .constant(.init()))
    }
}
