//
//  AppDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import SKAbstractions

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
  
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    configurators().configure()
    return true
  }
  
  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken
                   deviceToken: Data) {
    // If the AppMetrica SDK library was not initialized before this step,
    // calling the method causes the app to crash.
    // TODO: - Убрал пуши из яндекс, сделать новую реализацию
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
    // TODO: - Обработка пуша
  }
}

// MARK: - Private

private extension AppDelegate {
  func configurators() -> [Configurator] {
    return [
      ConfigurationValueConfigurator(services: ApplicationServicesImpl.shared)
    ]
  }
}
