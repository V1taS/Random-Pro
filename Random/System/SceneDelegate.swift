//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    @ObservedObject var storeManager = StoreManager()
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
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = .light
            window.rootViewController = UIHostingController( rootView: TabBarView(storeManager: storeManager)
                                                                .onAppear(perform: { [self] in
                                                                    storeManager.getProducts(productIDs: productIDs)
//                                                                    SKPaymentQueue.default().add(storeManager)
                                                                }))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

