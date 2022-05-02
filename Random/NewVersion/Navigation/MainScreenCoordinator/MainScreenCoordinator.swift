//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

final class MainScreenCoordinator: Coordinator {
    
    // MARK: - Private variables
    
    private let navigationController: UINavigationController
    private var mainScreenModule: MainScreenModule?
    
    // MARK: - Initialization
    
    /// - Parameters:
    ///   - navigationController: UINavigationController
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Internal func
    
    func start() {
        let mainScreenModule = MainScreenAssembly().createModule()
        self.mainScreenModule = mainScreenModule
        self.mainScreenModule?.moduleOutput = self
        navigationController.pushViewController(mainScreenModule, animated: true)
    }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
    func openNumber() {
        // TODO: - Open number
    }
}
