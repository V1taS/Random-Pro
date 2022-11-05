//
//  SceneDelegate.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//

import UIKit
import AppTrackingTransparency

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Internal property
  
  var window: UIWindow?
  
  // MARK: - Private property
  
  private var coordinator: Coordinator?
  
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
