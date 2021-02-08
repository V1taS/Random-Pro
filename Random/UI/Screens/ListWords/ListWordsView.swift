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
            
            Spacer()
            
            generateButton
        }
        .padding(.top, 16)
        .navigationBarTitle(Text("Список"), displayMode: .inline)
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
            
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: "Сгенерировать",
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

struct ListWordsView_Previews: PreviewProvider {
    static var previews: some View {
        ListWordsView(appBinding: .constant(.init()))
    }
}
