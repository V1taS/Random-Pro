//
//  MemesScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

final class MemesScreenCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var memesScreenModule: MemesScreenModule?
  
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
    var memesScreenModule = MemesScreenAssembly().createModule(services)
    self.memesScreenModule = memesScreenModule
    memesScreenModule.moduleOutput = self
    navigationController.pushViewController(memesScreenModule, animated: true)
  }
}

// MARK: - QuotesScreenModuleOutput

extension MemesScreenCoordinator: MemesScreenModuleOutput {
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - Private

private extension MemesScreenCoordinator {}

// MARK: - Appearance

private extension MemesScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}

