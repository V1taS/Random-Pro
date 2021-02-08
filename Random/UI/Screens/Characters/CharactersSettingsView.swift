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
                        Text("Без повторений")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text("Букв сгенерировано:")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.characters.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text("Последняя буква:")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.characters.listResult.wrappedValue.last ?? "нет")")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            
                        }) {
                            Text("Очистить")
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .inline)
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

struct CharactersSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersSettingsView(appBinding: .constant(.init()))
    }
}
