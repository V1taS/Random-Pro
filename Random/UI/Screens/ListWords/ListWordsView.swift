//
//  ListWordsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ListWordsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(appBinding.listWords.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                .onTapGesture {
                    generateWords(state: appBinding)
                    saveListWordsToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }
            
            Spacer()
            
            listResults
            generateButton
        }
        .padding(.top, 16)
        .navigationBarTitle(Text(NSLocalizedString("Список", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.listWords.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.listWords.showSettings, content: {
            ListWordsSettingsView(appBinding: appBinding)
        })
    }
}

private extension ListWordsView {
    var generateButton: some View {
        Button(action: {
            generateWords(state: appBinding)
            saveListWordsToUserDefaults(state: appBinding)
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

private extension ListWordsView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(appBinding.listWords.listResult.wrappedValue, id: \.self) { word in
                    Text("\(word)")
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
private extension ListWordsView {
    private func generateWords(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .generateWords(state: state)
    }
}

private extension ListWordsView {
    private func saveListWordsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .saveListWordsToUserDefaults(state: state)
    }
}

struct ListWordsView_Previews: PreviewProvider {
    static var previews: some View {
        ListWordsView(appBinding: .constant(.init()))
    }
}
