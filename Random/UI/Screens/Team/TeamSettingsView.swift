//
//  TeamSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TeamSettingsView: View {
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
                        Text(NSLocalizedString("Количество команд:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.team.selectedTeam.wrappedValue + 1)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: TeamCustomListView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список игроков", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    if !appBinding.team.listResult1.wrappedValue.isEmpty {
                        HStack {
                            NavigationLink(
                                destination: TeamResultsView(appBinding: appBinding)
                                    .allowAutoDismiss { false }) {
                                Text(NSLocalizedString("Результат генерации", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                            }
                            Spacer()
                        }
                    }
                    
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            
                            cleanTeams(state: appBinding)
                            appBinding.team.disabledPickerView.wrappedValue = false
                            saveTeamToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                                .font(.robotoRegular16())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            appBinding.team.listPlayersData.wrappedValue = []
                            saveTeamToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Удалить добавленных игроков", comment: ""))
                                .font(.robotoRegular16())
                                .foregroundColor(.primaryError())
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.team.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions clean Numbers
private extension TeamSettingsView {
    private func cleanTeams(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .cleanTeams(state: state)
    }
}

private extension TeamSettingsView {
    private func saveTeamToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .saveTeamToUserDefaults(state: state)
    }
}

struct TeamSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamSettingsView(appBinding: .constant(.init()))
    }
}

