//
//  ContactScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ContactScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var contactScreenModule: ContactScreenModule?
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
    var contactScreenModule = ContactScreenAssembly().createModule()
    self.contactScreenModule = contactScreenModule
    contactScreenModule.moduleOutput = self
    navigationController.pushViewController(contactScreenModule, animated: true)
  }
}

// MARK: - ContactScreenModuleOutput

extension ContactScreenCoordinator: ContactScreenModuleOutput {
  func settingButtonAction() {}
}
