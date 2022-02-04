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
    
    @Environment(\.viewController) private var viewControllerHolder: UIViewController?
    private var viewController: UIViewController? {
        self.viewControllerHolder!
    }
    
    private let reviewTrackingManager = ReviewTrackingManager()
    private let reviewUtility = RecordReviewApp()
    
    var body: some View {
        ZStack {
            TabView {
                MainView(appBinding: appBinding, actionButton: {
                    presentADV()
                })
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
        .sheet(isPresented: appBinding.premium.presentingModal, onDismiss: {}) {
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
        appBinding.adminOwner.premiumIsEnabled.wrappedValue = UserDefaults.standard.bool(forKey: GlobalConstants.ownerPremiumUserDefaultsID)
        appBinding.premium.premiumIsEnabled.wrappedValue = UserDefaults.standard.bool(forKey: GlobalConstants.premiumUserDefaultsID)

        guard !appBinding.adminOwner.premiumIsEnabled.wrappedValue else { return }
        
        let firstStart = UserDefaults.standard.bool(forKey: GlobalConstants.firstStart)
        
        if firstStart {
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
        } else {
            UserDefaults.standard.set(true, forKey: GlobalConstants.firstStart)
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

// MARK: Present ADV
private extension TabBarView {
    private func presentADV() {
        if !appBinding.premium.premiumIsEnabled.wrappedValue {
            if appBinding.adv.advCount.wrappedValue % GlobalConstants.adDisplayInterval == .zero {
                self.viewController?.present(style: .fullScreen, animated: false) {
                    NativeAdViewRepresentable(willDisappearAction: {
                        self.viewController?.dismiss(animated: true, completion: nil)
                    }, closeButtonAction: {
                        self.viewController?.dismiss(animated: true, completion: nil)
                    })
                }
            }
        }
    }
}



struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView(storeManager: .init())
    }
}
