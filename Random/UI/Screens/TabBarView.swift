//
//  TabBarView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    
    @ObservedObject var storeManager: StoreManager
    
    @State private var appState: AppState.AppData = .init()
    private var appBinding: Binding<AppState.AppData> {
        $appState.dispatched(to: injected.appState, \.appData)
    }
    
    @Environment(\.injected) private var injected: DIContainer
    
    private let reviewTrackingManager = ReviewTrackingManager()
    private let reviewUtility = ReviewUtility()
    
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
            reviewUtility.recordLaunch()
            loadPremiumStatus()
        }
        .sheet(isPresented: appBinding.premium.presentingModal, onDismiss: nil) {
            PremiumSubscriptionView(storeManager: storeManager, appBinding: appBinding)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            reviewTrackingManager.requestIDFA()
        }
    }
}

// MARK: Private
private extension TabBarView {
    func loadPremiumStatus() {
        appBinding.premium.premiumIsEnabled
            .wrappedValue = UserDefaults.standard
            .bool(forKey: GlobalConstants.premiumUserDefaultsID)
        DispatchQueue.main.async {
            storeManager.restoreProducts()
            storeManager.statePurchase = { status in
                appBinding.premium.premiumIsEnabled.wrappedValue = status
                UserDefaults.standard.set(status, forKey: GlobalConstants.premiumUserDefaultsID)
            }
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
        TabBarView(storeManager: .init())
    }
}
