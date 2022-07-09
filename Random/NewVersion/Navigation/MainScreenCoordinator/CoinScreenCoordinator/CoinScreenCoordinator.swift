//
//  CoinScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class CoinScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var coinScreenModule: CoinScreenModule?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let coinScreenModule = CoinScreenAssembly().createModule()
    self.coinScreenModule = coinScreenModule
    coinScreenModule.moduleOutput = self
    navigationController.pushViewController(coinScreenModule, animated: true)
  }
}

// MARK: - CoinScreenModuleOutput

extension CoinScreenCoordinator: CoinScreenModuleOutput {
  func settingsButtonAction() {
  }
}
