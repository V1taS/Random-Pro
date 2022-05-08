//
//  RootCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// Псевдоним для координатора. Первый параметр `Input`, второй `FinishFlowTypeObject`
///  По умолчанию `<Void, Void>`
typealias RootCoordinatorProtocol = Coordinator<Void, Void>

final class RootCoordinator: RootCoordinatorProtocol {
    
    // MARK: - Private variables
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var mainScreenCoordinator: MainScreenCoordinatorProtocol?
    private let services: ApplicationServices = ApplicationServicesImpl()
    
    
    // MARK: - Initialization
    
    /// - Parameter window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Internal func
    
    override func start(parameter: Void) {
        let mainScreenCoordinator: MainScreenCoordinatorProtocol = MainScreenCoordinator(navigationController,
                                                                                         services)
        self.mainScreenCoordinator = mainScreenCoordinator
        mainScreenCoordinator.start()
        
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
}
