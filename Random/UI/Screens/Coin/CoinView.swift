//
//  CoinView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CoinView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Text("\(appBinding.coin.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                .padding(.top, 16)
            
            Spacer()
            Image("\(appBinding.coin.listImage.wrappedValue[1])")
                .resizable()
                .frame(width: 200, height: 200)
                .shadow(radius: 10)
                .transition(.move(edge: .bottom))
                .animation(.easeOut(duration: 0.7))
            Spacer()
            
            generateButton
        }
        
        .navigationBarTitle(Text("Орел или Решка"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.coin.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.coin.showSettings, content: {
            CoinSettingsView(appBinding: appBinding)
        })
    }
}

private extension CoinView {
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

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(appBinding: .constant(.init()))
    }
}
