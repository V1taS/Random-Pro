//
//  ListWordsViewSettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ListWordsSettingsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Toggle(isOn: appBinding.listWords.noRepetitions) {
                        Text(NSLocalizedString("Без повторений", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последнее слово:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.listWords.listResult.wrappedValue.last ?? NSLocalizedString("нет", comment: ""))")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: CustomListWordsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            
                            Spacer()
                            
                            Text("\(appBinding.listWords.listData.wrappedValue.count)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            
                            Color.clear.frame(width: 10)
                        }
                        Spacer()
                    }
                    
                    if !appBinding.listWords.listResult.wrappedValue.isEmpty {
                        HStack {
                            NavigationLink(
                                destination: ListWordsResultsView(appBinding: appBinding)
                                    .allowAutoDismiss { false }) {
                                Text(NSLocalizedString("Результат генерации", comment: ""))
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                Spacer()
                                
                                Text("\(appBinding.listWords.listResult.wrappedValue.count)")
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                Color.clear.frame(width: 10)
                            }
                            Spacer()
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanWords(state: appBinding)
                            saveListWordsToUserDefaults(state: appBinding)
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
                            appBinding.listWords.listData.wrappedValue = []
                            saveListWordsToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Удалить элементы из списка", comment: ""))
                                .foregroundColor(.primaryError())
                                .font(.robotoRegular16())
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.listWords.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
        })
        }
    }
}

// MARK: Actions
private extension ListWordsSettingsView {
    private func cleanWords(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .cleanWords(state: state)
    }
}

private extension ListWordsSettingsView {
    private func saveListWordsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .saveListWordsToUserDefaults(state: state)
    }
}

struct ListWordsViewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ListWordsSettingsView(appBinding: .constant(.init()))
    }
}
