//
//  AppDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import YandexMobileMetrica
import FirebaseCore

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initializing the AppMetrica SDK.
    if let configuration = YMMYandexMetricaConfiguration.init(apiKey: "b4921e71-faf2-4bd3-8bea-e033a76457ae") {
      YMMYandexMetrica.activate(with: configuration)
    }
    FirebaseApp.configure()
    
    // TODO: - Жду появления Messaging в SPM
    //    Messaging.messaging().delegate = self
    //    UIApplication.shared.registerForRemoteNotifications()
    return true
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken
                   deviceToken: Data) {
    // TODO: - Жду появления Messaging в SPM
    //    Messaging.messaging().apnsToken = deviceToken
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

// MARK: - MessagingDelegate
// TODO: - Жду появления Messaging в SPM
//extension AppDelegate: MessagingDelegate {
//  func messaging(
//    _ messaging: Messaging,
//    didReceiveRegistrationToken fcmToken: String?
//  ) {
//    let tokenDict = ["token": fcmToken ?? ""]
//    NotificationCenter.default.post(
//      name: Notification.Name("FCMToken"),
//      object: nil,
//      userInfo: tokenDict)
//  }
//}
