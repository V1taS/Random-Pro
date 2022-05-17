//
//  CoinScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 17.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

typealias CoinScreenCoordinatorProtocol = Coordinator<Void, Void>

final class CoinScreenCoordinator: CoinScreenCoordinatorProtocol {
    
    // MARK: - Private property
    
    private let navigationController: UINavigationController
    private var coinScreenModule: CoinScreenModule?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal func
    
    override func start(parameter: Void) {
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
