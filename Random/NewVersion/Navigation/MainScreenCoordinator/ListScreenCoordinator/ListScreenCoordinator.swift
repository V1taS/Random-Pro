//
//  ListScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ListScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var listScreenModule: ListScreenModule?
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
    var listScreenModule = ListScreenAssembly().createModule()
    self.listScreenModule = listScreenModule
    listScreenModule.moduleOutput = self
    navigationController.pushViewController(listScreenModule, animated: true)
  }
}

// MARK: - ListScreenModuleOutput

extension ListScreenCoordinator: ListScreenModuleOutput {}
