//
//  AdminFeatureToggleCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol AdminFeatureToggleCoordinatorOutput: AnyObject { }

protocol AdminFeatureToggleCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: AdminFeatureToggleCoordinatorOutput? { get set }
}

typealias AdminFeatureToggleCoordinatorProtocol = AdminFeatureToggleCoordinatorInput & Coordinator

final class AdminFeatureToggleCoordinator: AdminFeatureToggleCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: AdminFeatureToggleCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var adminFeatureToggleModule: AdminFeatureToggleModule?
  private let services: ApplicationServices
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  ///   - services: Сервисы приложения
  init(_ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    let adminFeatureToggleModule = AdminFeatureToggleAssembly().createModule()
    self.adminFeatureToggleModule = adminFeatureToggleModule
    self.adminFeatureToggleModule?.moduleOutput = self
    navigationController.present(adminFeatureToggleModule, animated: true)
  }
}

// MARK: - AdminFeatureToggleModuleOutput

extension AdminFeatureToggleCoordinator: AdminFeatureToggleModuleOutput {
  func loginOrPasswordError() {
    
  }
}
