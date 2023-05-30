//
//  BottleScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol BottleScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol BottleScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: BottleScreenCoordinatorOutput? { get set }
}

typealias BottleScreenCoordinatorProtocol = BottleScreenCoordinatorInput & Coordinator

final class BottleScreenCoordinator: BottleScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: BottleScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var bottleScreenModule: BottleScreenModule?
  
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
    var bottleScreenModule = BottleScreenAssembly().createModule(services)
    self.bottleScreenModule = bottleScreenModule
    bottleScreenModule.moduleOutput = self
    navigationController.pushViewController(bottleScreenModule, animated: true)
  }
}

// MARK: - BottleScreenModuleOutput

extension BottleScreenCoordinator: BottleScreenModuleOutput {}
