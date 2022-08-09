//
//  MoviesScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class MoviesScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var moviesScreenModule: MoviesScreenModule?
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
    var moviesScreenModule = MoviesScreenAssembly().createModule()
    self.moviesScreenModule = moviesScreenModule
    moviesScreenModule.moduleOutput = self
    navigationController.pushViewController(moviesScreenModule, animated: true)
  }
}

extension MoviesScreenCoordinator: MoviesScreenModuleOutput {}
