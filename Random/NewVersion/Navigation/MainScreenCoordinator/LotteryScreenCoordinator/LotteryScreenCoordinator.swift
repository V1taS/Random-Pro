//
//  LotteryScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 18.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

final class LotteryScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var lotteryScreenModule: LotteryScreenModule?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let lotteryScreenModule = LotteryScreenAssembly().createModule()
    self.lotteryScreenModule = lotteryScreenModule
    lotteryScreenModule.moduleOutput = self
    navigationController.pushViewController(lotteryScreenModule, animated: true)
  }
}

// MARK: - LotteryScreenModuleOutput

extension LotteryScreenCoordinator: LotteryScreenModuleOutput {
  
}
