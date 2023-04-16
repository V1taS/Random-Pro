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
  private let services: ApplicationServices = ApplicationServicesImpl()
  
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
    print("Ошибка для теста, большой отступ")
    YMPYandexMetricaPush.handleSceneWillConnectToSession(with: connectionOptions)
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    coordinator?.sceneDidBecomeActive()
    
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
    services.deepLinkService.eventHandlingWith(urlContexts: URLContexts)
  }
}
