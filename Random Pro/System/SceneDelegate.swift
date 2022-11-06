//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import AppTrackingTransparency
import YandexMobileMetricaPush

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Internal property
  
  var window: UIWindow?
  
  // MARK: - Private property
  
  private var coordinator: RootCoordinatorProtocol?
  
  // MARK: - Internal func
  
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = scene as? UIWindowScene else { return }
    let window = UIWindow(windowScene: scene)
    let coordinator = RootCoordinator(window: window)
    self.coordinator = coordinator
    coordinator.start()
    self.window = window
    YMPYandexMetricaPush.handleSceneWillConnectToSession(with: connectionOptions)
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
      if #available(iOS 14, *) {
        switch ATTrackingManager.trackingAuthorizationStatus {
        case .notDetermined:
          ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
        default: break
        }
      }
    }
  }
}

// MARK: - Deep links

extension SceneDelegate {
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    coordinator?.scene(scene, openURLContexts: URLContexts)
  }
}
