//
//  RaffleScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol RaffleScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol RaffleScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: RaffleScreenCoordinatorOutput? { get set }
}

typealias RaffleScreenCoordinatorProtocol = RaffleScreenCoordinatorInput & Coordinator

final class RaffleScreenCoordinator: RaffleScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: RaffleScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var raffleScreenModule: RaffleScreenModule?
  
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
    let raffleScreenModule = RaffleScreenAssembly().createModule(authenticationService: services.authenticationService)
    self.raffleScreenModule = raffleScreenModule
    self.raffleScreenModule?.moduleOutput = self
    navigationController.pushViewController(raffleScreenModule, animated: true)
  }
}

// MARK: - RaffleScreenModuleOutput

extension RaffleScreenCoordinator: RaffleScreenModuleOutput {
  func authorizationError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().authorizationError,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - Appearance

private extension RaffleScreenCoordinator {
  struct Appearance {
    let authorizationError = NSLocalizedString("Ошибка авторизации", comment: "")
  }
}
