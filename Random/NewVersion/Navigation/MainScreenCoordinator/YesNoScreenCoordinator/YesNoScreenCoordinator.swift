//
//  YesNoScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 12.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

typealias YesNoScreenCoordinatorProtocol = Coordinator<Void, String>

final class YesNoScreenCoordinator: YesNoScreenCoordinatorProtocol {

    // MARK: - Private property
    
    private let navigationController: UINavigationController
    private var yesNoScreenModule: YesNoScreenModule?
    
    // MARK: - Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal func
    
    override func start(parameter: Void) {
        let yesNoScreenModule = YesNoScreenAssembly().createModule()
        self.yesNoScreenModule = yesNoScreenModule
        yesNoScreenModule.moduleOutput = self
        navigationController.pushViewController(yesNoScreenModule, animated: true)
    }
}

// MARK: - YesNoScreenModuleOutput

extension YesNoScreenCoordinator: YesNoScreenModuleOutput {
    func settingButtonAction() {
        
    } 
}
