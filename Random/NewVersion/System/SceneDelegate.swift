//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import SwiftUI
import StoreKit

enum AppVersion {
    case new
    case old
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    @ObservedObject private var storeManager = StoreManager()
    
    @Environment(\.injected) private var injected: DIContainer
    
    private var orientation = Orientation()
    private let productIDs = ProductSubscriptionIDs.allSubscription
    private var coordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            
            // MARK: - Переключатель версии
            switchOldToNew(version: .new, windowScene: windowScene, showPerformance: false)
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        orientation.isLandScape = windowScene.interfaceOrientation.isLandscape
    }
    
    private func switchOldToNew(version: AppVersion, windowScene: UIWindowScene, showPerformance: Bool = false) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        window.overrideUserInterfaceStyle = .light
        
        if showPerformance {
            FPSCounter.showInStatusBar(windowScene: windowScene)
        }
        
        switch version {
        case .new:
            let coordinator = RootCoordinator(window: window)
            coordinator.start()
            self.coordinator = coordinator
        case .old:
            window.rootViewController = UIHostingController(rootView: TabBarView(storeManager: storeManager)
                .environmentObject(orientation)
                .onAppear(perform: { [self] in
                    SKPaymentQueue.default().add(storeManager)
                    storeManager.getProducts(productIDs: productIDs)
                    
                }))
            window.makeKeyAndVisible()
        }
    }
}
