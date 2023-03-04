//
//  AppDelegate.swift
//  LetterScreenModuleExample
//
//  Created by Sosin_Vitalii on 24/02/2023.
//  Copyright © 2023 Sosin Vitalii. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    let viewController = UIViewController()
    window.rootViewController = viewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}