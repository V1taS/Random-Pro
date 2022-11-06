//
//  RootCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol RootCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol RootCoordinatorInput {
  
  /// События Deep links
  ///  - Parameters:
  ///   - scene: Сцена
  ///   - URLContexts: Сыылки url
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>)
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: RootCoordinatorOutput? { get set }
}

typealias RootCoordinatorProtocol = RootCoordinatorInput & Coordinator

final class RootCoordinator: RootCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: RootCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let window: UIWindow
  private let navigationController = UINavigationController()
  private var mainScreenCoordinator: MainScreenCoordinatorProtocol?
  private let services: ApplicationServices = ApplicationServicesImpl()
  
  
  // MARK: - Initialization
  
  /// - Parameter window: UIWindow
  init(window: UIWindow) {
    self.window = window
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenCoordinator = MainScreenCoordinator(window,
                                                      navigationController,
                                                      services)
    self.mainScreenCoordinator = mainScreenCoordinator
    mainScreenCoordinator.start()
    
    window.makeKeyAndVisible()
    window.rootViewController = navigationController
  }
  
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    services.deepLinkService.scene(scene, openURLContexts: URLContexts) { deepLinkType in
      mainScreenCoordinator?.scene(scene, openURLContexts: URLContexts, deepLinkType: deepLinkType)
    }
  }
}
