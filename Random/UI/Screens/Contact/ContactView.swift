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
    @State private var isPressedButton = false
    @State private var isPressedTouch = false
    
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
                        .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                        .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
                        
                        .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                    .onChanged { _ in
                                        isPressedTouch = true
                                        generateContacts(state: appBinding)
                                        saveContactToUserDefaults(state: appBinding)
                                        Feedback.shared.impactHeavy(.medium)
                                    }
                                    .onEnded { _ in
                                        isPressedTouch = false
                                    }
                        )
                    
                } else {
                    VStack(spacing: 24) {
                        Text("\(appBinding.contact.resultFullName.wrappedValue)")
                            .font(.robotoBold30())
                            .foregroundColor(.primaryGray())
                            .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                            .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
                            .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                        
                        Text("\(appBinding.contact.resultPhone.wrappedValue)")
                            .font(.robotoBold30())
                            .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                            .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                            .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
                            .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
                            .padding(.horizontal, 24)
                    }
                    
                    .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                                .onChanged { _ in
                                    isPressedTouch = true
                                    generateContacts(state: appBinding)
                                    saveContactToUserDefaults(state: appBinding)
                                    Feedback.shared.impactHeavy(.medium)
                                }
                                .onEnded { _ in
                                    isPressedTouch = false
                                }
                    )
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
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
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
