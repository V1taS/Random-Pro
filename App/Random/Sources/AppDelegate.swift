//
//  AppDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import YandexMobileMetricaPush
import YandexMobileMetrica
import Firebase
import ApphudSDK

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
       let options =  FirebaseOptions(contentsOfFile: plistPath),
        FirebaseApp.app() == nil {
      FirebaseApp.configure(options: options)
    }
    
    if let configuration = YMMYandexMetricaConfiguration.init(apiKey: "b4921e71-faf2-4bd3-8bea-e033a76457ae") {
      YMMYandexMetrica.activate(with: configuration)
    }
    
    Apphud.start(apiKey: "app_YENSAYJtWZqqJyG2kMevtnSB4nv5Qf")
    return true
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken
                   deviceToken: Data) {
    // If the AppMetrica SDK library was not initialized before this step,
    // calling the method causes the app to crash.
#if DEBUG
    let pushEnvironment = YMPYandexMetricaPushEnvironment.development
#else
    let pushEnvironment = YMPYandexMetricaPushEnvironment.production
#endif
    YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken, pushEnvironment: pushEnvironment)
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication,
                   configurationForConnecting connectingSceneSession: UISceneSession,
                   options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfiguration = UISceneConfiguration(name: "Default Configuration",
                                                  sessionRole: connectingSceneSession.role)
    sceneConfiguration.delegateClass = SceneDelegate.self
    return sceneConfiguration
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

// MARK: - Configure handling the opening of push notifications

extension AppDelegate {
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    self.handlePushNotification(userInfo)
  }
  
  func application(_ application: UIApplication,
                   didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                   fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    self.handlePushNotification(userInfo)
    completionHandler(.newData)
  }
  
  func handlePushNotification(_ userInfo: [AnyHashable: Any]) {
    // Track received remote notification.
    // Method [YMMYandexMetrica activateWithApiKey:] should be called before using this method.
    YMPYandexMetricaPush.handleRemoteNotification(userInfo)
  }
}
