//
//  YesOrNotView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct YesOrNotView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State private var isPressedButton = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(appBinding.yesOrNo.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton)
            
            Spacer()
            listResults
            generateButton
        }.onAppear(perform: {
            AppMetrics.trackEvent(name: .yesOrNotScreen)
        })
        .navigationBarTitle(Text(NSLocalizedString("Да или Нет", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.yesOrNo.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
        })
        .sheet(isPresented: appBinding.yesOrNo.showSettings, content: {
            YesOrNotSettingsView(appBinding: appBinding)
        })
    }
}

private extension YesOrNotView {
    var generateButton: some View {
        Button(action: {
            generateYesOrNo(state: appBinding)
            saveYesOrNotToUserDefaults(state: appBinding)
            Feedback.shared.impactHeavy(.medium)
            actionButton?()
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Да или Нет?", comment: ""),
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

private extension YesOrNotView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(appBinding.yesOrNo.listResult
                                .wrappedValue.enumerated()), id: \.0) { (index, element) in
                    if index == 0 {
                        TextRoundView(name: "\(element)")
                            .opacity(isPressedButton ? 0.8 : 1)
                            .scaleEffect(isPressedButton ? 0.9 : 1)
                            .animation(.easeInOut(duration: 0.1), value: isPressedButton)
                    } else {
                        Text("\(element)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

// MARK: Actions
private extension YesOrNotView {
    private func generateYesOrNo(state: Binding<AppState.AppData>) {
        injected.interactors.yesOrNoInteractor.generateYesOrNo(state: state)
    }
}

private extension YesOrNotView {
    private func saveYesOrNotToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.yesOrNoInteractor
            .saveYesOrNoToUserDefaults(state: state)
    }
}

struct YesOrNotView_Previews: PreviewProvider {
    static var previews: some View {
        YesOrNotView(appBinding: .constant(.init()), actionButton: nil)
    }
}
