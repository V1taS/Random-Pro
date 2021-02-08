//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.overrideUserInterfaceStyle = .light
            window.rootViewController = UIHostingController( rootView: TabBarView())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

