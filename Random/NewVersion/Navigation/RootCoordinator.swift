//
//  RootCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

final class RootCoordinator: Coordinator {
    
    // MARK: - Private variables
    
    private let window: UIWindow
    private let navigationController = UINavigationController()
    private var mainScreenCoordinator: Coordinator?
    
    
    // MARK: - Initialization
    
    /// - Parameter window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Internal func
    
    func start() {
        let mainScreenCoordinator: Coordinator = MainScreenCoordinator(navigationController)
        self.mainScreenCoordinator = mainScreenCoordinator
        mainScreenCoordinator.start()
        
        window.makeKeyAndVisible()
        window.rootViewController = navigationController
    }
}
