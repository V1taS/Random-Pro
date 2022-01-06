//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import SwiftUI
import StoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    @ObservedObject var storeManager = StoreManager()
    var orientation = Orientation()
    private let productIDs = [
        "com.sosinvitalii.Random.TipForTea",
        "com.sosinvitalii.Random.TipForWine",
        "com.sosinvitalii.Random.TipForBreakfast",
        "com.sosinvitalii.Random.TipForLunch",
        "com.sosinvitalii.Random.TipForDinner",
        "com.sosinvitalii.Random.TipForDateWithMyGirlfriend",
        "com.sosinvitalii.Random.TipForTravel"
    ]

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
//            FPSCounter.showInStatusBar(windowScene: windowScene)
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = .light
            window.rootViewController = UIHostingController( rootView: TabBarView(storeManager: storeManager)
                                                                .environmentObject(orientation)
                                                                .onAppear(perform: { [self] in
                                                                    SKPaymentQueue.default().add(storeManager)
                                                                    storeManager.getProducts(productIDs: productIDs)
                                                                    
                                                                }))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        orientation.isLandScape = windowScene.interfaceOrientation.isLandscape
    }
}

