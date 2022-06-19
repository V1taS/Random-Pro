//
//  NumberScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

final class NumberScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var numberScreenModule: NumberScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController, services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    let numberScreenModule = NumberScreenAssembly().createModule(keyboardService: services.keyboardService)
    self.numberScreenModule = numberScreenModule
    numberScreenModule.moduleOutput = self
    navigationController.pushViewController(numberScreenModule, animated: true)
  }
}

// MARK: - NumberScreenModuleOutput

extension NumberScreenCoordinator: NumberScreenModuleOutput {
  func settingButtonAction(model: NumberScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController: navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension NumberScreenCoordinator: SettingsScreenCoordinatorOutput {
  
}
