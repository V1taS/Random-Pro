//
//  FilmsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol FilmsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol FilmsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: FilmsScreenCoordinatorOutput? { get set }
}

typealias FilmsScreenCoordinatorProtocol = FilmsScreenCoordinatorInput & Coordinator

final class FilmsScreenCoordinator: FilmsScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: FilmsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var filmsScreenModule: FilmsScreenModule?
  
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
    let filmsScreenModule = FilmsScreenAssembly().createModule()
    self.filmsScreenModule = filmsScreenModule
    self.filmsScreenModule?.moduleOutput = self
    navigationController.pushViewController(filmsScreenModule, animated: true)
  }
}

// MARK: - FilmsScreenModuleOutput

extension FilmsScreenCoordinator: FilmsScreenModuleOutput {}

// MARK: - Appearance

private extension FilmsScreenCoordinator {
  struct Appearance {}
}
