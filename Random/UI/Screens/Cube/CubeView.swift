//
//  CubeView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CubeView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .navigationBarTitle(Text("Кубики"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.cube.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.coin.showSettings, content: {
            CoinSettingsView(appBinding: appBinding)
        })
    }
}

struct CubeView_Previews: PreviewProvider {
    static var previews: some View {
        CubeView(appBinding: .constant(.init()))
    }
}
