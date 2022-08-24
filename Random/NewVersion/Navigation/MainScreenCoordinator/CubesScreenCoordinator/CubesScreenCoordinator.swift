//
//  CubesScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class CubesScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var cubesScreenModule: CubesScreenModule?
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
    var cubesScreenModule = CubesScreenAssembly().createModule()
    self.cubesScreenModule = cubesScreenModule
    cubesScreenModule.moduleOutput = self
    navigationController.pushViewController(cubesScreenModule, animated: true)
  }
}

// MARK: - CubesScreenModuleOutput

extension CubesScreenCoordinator: CubesScreenModuleOutput {}
