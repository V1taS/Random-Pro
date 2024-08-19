//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import AppTrackingTransparency
import YandexMobileMetricaPush
import FirebaseDynamicLinks

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Internal property
  
  var window: UIWindow?
  
  // MARK: - Private property
  
  private var coordinator: RootCoordinatorProtocol?
  private let services: ApplicationServices = ApplicationServicesImpl.shared
  private var deepLimkURL: URL?
  
  // MARK: - Internal func
  
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: scene)
    let coordinator = RootCoordinator(window, services)
    self.coordinator = coordinator
    coordinator.start()
    self.window = window
    YMPYandexMetricaPush.handleSceneWillConnectToSession(with: connectionOptions)
    
    if let urlContext = connectionOptions.urlContexts.first {
      self.deepLimkURL = urlContext.url
    }
    
    if let userActivity = connectionOptions.userActivities.first {
      self.handleDynamicLink(userActivity: userActivity)
    }
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    if let deepLimkURL {
      services.deepLinkService.eventHandlingWith(deepLimkURL: deepLimkURL)
      self.deepLimkURL = nil
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      if #available(iOS 14, *) {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        default: break
        }
      }
    }
    coordinator?.sceneDidBecomeActive()
    services.featureToggleServices.fetchRemoteConfig { _ in }
  }
  
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    handleDynamicLink(userActivity: userActivity)
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      self.deepLimkURL = url
    }
  }
}

// MARK: - Private

private extension SceneDelegate {
  func handleDynamicLink(userActivity: NSUserActivity) {
    guard let dynamiclink = userActivity.webpageURL else {
      return
    }
    
    self.deepLimkURL = dynamiclink
  }
}
