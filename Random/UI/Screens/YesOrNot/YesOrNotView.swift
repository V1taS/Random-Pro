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
            Spacer()
            generateButton
            
        }
        .navigationBarTitle(Text("Да или Нет"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.yesOrNo.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.yesOrNo.showSettings, content: {
            YesOrNotSettingsView(appBinding: appBinding)
        })
    }
}

private extension YesOrNotView {
    var generateButton: some View {
        Button(action: {
            
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: "Да или Нет?",
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

struct YesOrNotView_Previews: PreviewProvider {
    static var previews: some View {
        YesOrNotView(appBinding: .constant(.init()))
    }
}
