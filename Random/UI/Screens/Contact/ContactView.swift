//
//  ContactView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 22.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ContactView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        ZStack {
            Color(.clear)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Spacer()
                
                if appBinding.contact.listResults.wrappedValue.isEmpty {
                    Text("?")
                        .font(.robotoBold70())
                        .foregroundColor(.primaryGray())
                        .padding(.horizontal, 16)
                        .onTapGesture {
                            generateContacts(state: appBinding)
                            saveContactToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }
                } else {
                    VStack(spacing: 24) {
                        Text("\(appBinding.contact.resultFullName.wrappedValue)")
                            .font(.robotoBold30())
                            .foregroundColor(.primaryGray())
                            .padding(.horizontal, 16)
                        
                        Text("\(appBinding.contact.resultPhone.wrappedValue)")
                            .font(.robotoBold30())
                            .gradientForeground(colors: [Color.primaryGreen(), Color.primaryTertiary()])
                            .padding(.horizontal, 16)
                    }
                    .onTapGesture {
                        generateContacts(state: appBinding)
                        saveContactToUserDefaults(state: appBinding)
                        Feedback.shared.impactHeavy(.medium)
                    }
                }
                Spacer()
                
                generateButton
            }
            .padding(.top, 16)
            
            .navigationBarTitle(Text(NSLocalizedString("Контакт", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.contact.showSettings.wrappedValue.toggle()
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 24))
            })
            .sheet(isPresented: appBinding.contact.showSettings, content: {
                ContactSettingsView(appBinding: appBinding)
            })
        }
        .dismissingKeyboard()
    }
}

private extension ContactView {
    var generateButton: some View {
        Button(action: {
            generateContacts(state: appBinding)
            saveContactToUserDefaults(state: appBinding)
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

// MARK: Actions
private extension ContactView {
    private func generateContacts(state: Binding<AppState.AppData>) {
        injected.interactors.contactInteractor
            .generateContacts(state: state)
    }
}

private extension ContactView {
    private func saveContactToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.contactInteractor
            .saveContactToUserDefaults(state: state)
    }
}


struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView(appBinding: .constant(.init()))
    }
}
