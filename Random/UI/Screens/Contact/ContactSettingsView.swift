//
//  ContactSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 22.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ContactSettingsView: View {
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
                        NavigationLink(
                            destination: ContactResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список контактов", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            
                            Spacer()
                            
                            Text("\(appBinding.contact.listResults.wrappedValue.count)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            
                            Color.clear.frame(width: 10)
                        }
                        Spacer()
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
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.contact.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions
private extension ContactSettingsView {
    private func cleanContacts(state: Binding<AppState.AppData>) {
        injected.interactors.contactInteractor
            .cleanContacts(state: state)
    }
}

private extension ContactSettingsView {
    private func saveContactToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.contactInteractor
            .saveContactToUserDefaults(state: state)
    }
}

struct ContactSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactSettingsView(appBinding: .constant(.init()))
    }
}
