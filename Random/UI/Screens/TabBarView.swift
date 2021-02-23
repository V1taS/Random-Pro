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
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        ZStack {
            
            TabView {
                MainView(appBinding: appBinding)
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                        Text(NSLocalizedString("Генераторы", comment: ""))
                }
                
                SettingsView(appBinding: appBinding, storeManager: storeManager)
                    .tabItem {
                        Image(systemName: "gear")
                        Text(NSLocalizedString("Настройки", comment: ""))
                    }
            }
            .accentColor(Color.primaryGray())
            backgroundColor
            showAddPlayerView
        }
        .onAppear {
            ReviewUtility.sharedInstance.recordLaunch()
        }
    }
}


// MARK: Sheet View
private extension TabBarView {
    private var showAddPlayerView: AnyView {
        AnyView(
            VStack {
                Spacer()
                AddPlayerSheet(appBinding: appBinding)
                    .offset(y: 50)
            }
        )
    }
    
    private var backgroundColor: some View {
        ZStack {
            if appBinding.team.showAddPlayer.wrappedValue {
                Color.secondary
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onTapGesture {
            appBinding.team.showAddPlayer.wrappedValue = false
        }
        .transition(.move(edge: .bottom))
        .animation(.easeOut(duration: 0.5))
    }
}



struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(storeManager: StoreManager())
    }
}
