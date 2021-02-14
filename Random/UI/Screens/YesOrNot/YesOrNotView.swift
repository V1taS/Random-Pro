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
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(appBinding.yesOrNo.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                .onTapGesture {
                    generateYesOrNo(state: appBinding)
                    saveYesOrNotToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }
            Spacer()
            listResults
            generateButton
        }
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
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Да или Нет?", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

private extension YesOrNotView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(appBinding.yesOrNo.listResult.wrappedValue, id: \.self) { element in
                    
                    Text("\(element)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
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
        YesOrNotView(appBinding: .constant(.init()))
    }
}
