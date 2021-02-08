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
                        Text("Без повторений")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text("Слов сгенерировано:")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.listWords.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text("Последнее слово:")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.listWords.listResult.wrappedValue.last ?? "нет")")
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
                appBinding.listWords.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
        })
        }
    }
}

struct ListWordsViewSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ListWordsSettingsView(appBinding: .constant(.init()))
    }
}
