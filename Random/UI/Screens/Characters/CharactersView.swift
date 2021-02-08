//
//  CharactersView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CharactersView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Picker(selection: appBinding.characters.selectedLang,
                   label: Text("Picker")) {
                ForEach(0..<appBinding.characters.lang.wrappedValue.count) {
                    Text("\(appBinding.characters.lang.wrappedValue[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 16)
            
            Spacer()
            Text("\(appBinding.characters.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
            
            Spacer()
            
            listResults
            generateButton
        }
        .padding(.horizontal, 16)
        
        .navigationBarTitle(Text("Буква"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.characters.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.characters.showSettings, content: {
            CharactersSettingsView(appBinding: appBinding)
        })
    }
}

private extension CharactersView {
    var generateButton: some View {
        Button(action: {
            
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: "Сгенерировать букву",
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

private extension CharactersView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(appBinding.yesOrNo.listResult.wrappedValue, id: \.self) { number in
                    
                    Text("\(number)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView(appBinding: .constant(.init()))
    }
}

