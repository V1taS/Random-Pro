//
//  YesOrNotSettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct YesOrNotSettingsView: View {
    
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
                        Text(NSLocalizedString("Cгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.yesOrNo.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последнее слово:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.yesOrNo.listResult.wrappedValue.last ?? NSLocalizedString("нет", comment: ""))")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: YesOrNotResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список ответов", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanNumber(state: appBinding)
                            saveYesOrNotToUserDefaults(state: appBinding)
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
                appBinding.yesOrNo.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions
private extension YesOrNotSettingsView {
    private func cleanNumber(state: Binding<AppState.AppData>) {
        injected.interactors.yesOrNoInteractor
            .cleanNumber(state: state)
    }
}

private extension YesOrNotSettingsView {
    private func saveYesOrNotToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.yesOrNoInteractor
            .saveYesOrNoToUserDefaults(state: state)
    }
}

struct YesOrNotSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        YesOrNotSettingsView(appBinding: .constant(.init()))
    }
}
