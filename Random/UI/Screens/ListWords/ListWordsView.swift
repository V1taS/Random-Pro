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
    @State private var isPressedButton = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(appBinding.listWords.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton)
            
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
                .font(.system(size: 24))
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
            if !appBinding.listWords.listTemp.wrappedValue.isEmpty {
                Feedback.shared.impactHeavy(.medium)
            }
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

private extension ListWordsView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(appBinding.listWords.listResult
                                .wrappedValue.enumerated()), id: \.0) { (index, word) in
                    
                    if index == 0 {
                        TextRoundView(name: "\(word)")
                            .opacity(isPressedButton ? 0.8 : 1)
                            .scaleEffect(isPressedButton ? 0.9 : 1)
                            .animation(.easeInOut(duration: 0.1), value: isPressedButton)
                    } else {
                        Text("\(word)")
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
