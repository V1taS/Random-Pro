//
//  AppDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import YandexMobileMetrica
import YandexMobileMetricaPush
import Firebase
import ApphudSDK
import GoogleMobileAds

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    if let configuration = YMMYandexMetricaConfiguration.init(apiKey: SecretsAPI.apiKeyYandexMetrica) {
      YMMYandexMetrica.activate(with: configuration)
    }
    FirebaseApp.configure()
    Apphud.start(apiKey: SecretsAPI.apiKeyApphud)
    GADMobileAds.sharedInstance().start(completionHandler: nil)
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
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
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
