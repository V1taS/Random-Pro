//
//  SelecteAppIconScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol SelecteAppIconScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol SelecteAppIconScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: SelecteAppIconScreenCoordinatorOutput? { get set }
}

typealias SelecteAppIconScreenCoordinatorProtocol = SelecteAppIconScreenCoordinatorInput & Coordinator

final class SelecteAppIconScreenCoordinator: SelecteAppIconScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: SelecteAppIconScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var selecteAppIconScreenModule: SelecteAppIconScreenModule?
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
    let selecteAppIconScreenModule = SelecteAppIconScreenAssembly().createModule()
    self.selecteAppIconScreenModule = selecteAppIconScreenModule
    self.selecteAppIconScreenModule?.moduleOutput = self
    navigationController.pushViewController(selecteAppIconScreenModule, animated: true)
  }
}

// MARK: - SelecteAppIconScreenModuleOutput

extension SelecteAppIconScreenCoordinator: SelecteAppIconScreenModuleOutput {}

// MARK: - Appearance

private extension SelecteAppIconScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
  }
}
