//
//  CharactersSettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CharactersSettingsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Toggle(isOn: appBinding.characters.noRepetitions) {
                        Text(NSLocalizedString("Без повторений", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Cгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.characters.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последняя буква:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.characters.listResult.wrappedValue.last ?? NSLocalizedString("нет", comment: ""))")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: CharactersResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список букв", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanCharacters(state: appBinding)
                            saveCharactersToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.characters.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions
private extension CharactersSettingsView {
    private func cleanCharacters(state: Binding<AppState.AppData>) {
        injected.interactors.charactersInteractor
            .cleanCharacters(state: state)
    }
}

private extension CharactersSettingsView {
    private func saveCharactersToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.charactersInteractor
            .saveCharactersToUserDefaults(state: state)
    }
}

struct CharactersSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersSettingsView(appBinding: .constant(.init()))
    }
}
