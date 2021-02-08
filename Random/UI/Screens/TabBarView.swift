//
//  TabBarView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var appState: AppState.AppData = .init()
    private var appBinding: Binding<AppState.AppData> {
        $appState.dispatched(to: injected.appState, \.appData)
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        TabView {
            
            MainView(appBinding: appBinding)
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Генератор")
                }
            
            MainView(appBinding: appBinding)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Настройки")
                }
        }
        .accentColor(Color.primaryGray())
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
