//
//  UpdateAppScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol UpdateAppScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol UpdateAppScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: UpdateAppScreenCoordinatorOutput? { get set }
}

typealias UpdateAppScreenCoordinatorProtocol = UpdateAppScreenCoordinatorInput & Coordinator

final class UpdateAppScreenCoordinator: UpdateAppScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: UpdateAppScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var updateAppScreenModule: UpdateAppScreenModule?
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
    let updateAppScreenModule = UpdateAppScreenAssembly().createModule()
    self.updateAppScreenModule = updateAppScreenModule
    self.updateAppScreenModule?.moduleOutput = self
    
    navigationController.pushViewController(updateAppScreenModule, animated: true)
  }
}

// MARK: - UpdateAppScreenModuleOutput

extension UpdateAppScreenCoordinator: UpdateAppScreenModuleOutput {}

// MARK: - Appearance

private extension UpdateAppScreenCoordinator {
  struct Appearance {}
}
