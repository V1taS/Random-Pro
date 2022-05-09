//
//  NumberScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

typealias NumberScreenCoordinatorProtocol = Coordinator<Void, String>

final class NumberScreenCoordinator: NumberScreenCoordinatorProtocol {
    
    // MARK: - Private property
    
    private let navigationController: UINavigationController
    private let services: ApplicationServices
    private var numberScreenModule: NumberScreenModule?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController, services: ApplicationServices) {
        self.navigationController = navigationController
        self.services = services
    }
    
    // MARK: - Internal func
    
    override func start(parameter: Void) {
        let numberScreenModule = NumberScreenAssembly().createModule(keyboardService: services.keyboardService)
        self.numberScreenModule = numberScreenModule
        numberScreenModule.moduleOutput = self
        navigationController.pushViewController(numberScreenModule, animated: true)
    }
}

// MARK: - NumberScreenModuleOutput

extension NumberScreenCoordinator: NumberScreenModuleOutput {
    func settingButtonAction() {
        // TODO: - Open setting screen
    }
}
