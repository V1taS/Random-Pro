//
//  PasswordScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class PasswordScreenCoordinator: Coordinator {
 
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var passwordScreenModule: PasswordScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    var passwordScreenModule = PasswordScreenAssembly().createModule()
    self.passwordScreenModule = passwordScreenModule
    passwordScreenModule.moduleOutput = self
    navigationController.pushViewController(passwordScreenModule, animated: true)
  }
}

extension PasswordScreenCoordinator: PasswordScreenModuleOutput {}
