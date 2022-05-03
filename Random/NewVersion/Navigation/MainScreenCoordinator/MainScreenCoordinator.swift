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
    func openFilms() {
        // TODO: - Open Coordinator
    }
    
    func openTeams() {
        // TODO: - Open Coordinator
    }
    
    func openYesOrNo() {
        // TODO: - Open Coordinator
    }
    
    func openCharacter() {
        // TODO: - Open Coordinator
    }
    
    func openList() {
        // TODO: - Open Coordinator
    }
    
    func openCoin() {
        // TODO: - Open Coordinator
    }
    
    func openCube() {
        // TODO: - Open Coordinator
    }
    
    func openDateAndTime() {
        // TODO: - Open Coordinator
    }
    
    func openLottery() {
        // TODO: - Open Coordinator
    }
    
    func openContact() {
        // TODO: - Open Coordinator
    }
    
    func openMusic() {
        // TODO: - Open Coordinator
    }
    
    func openTravel() {
        // TODO: - Open Coordinator
    }
    
    func openPassword() {
        // TODO: - Open Coordinator
    }
    
    func openRussianLotto() {
        // TODO: - Open Coordinator
    }
    
    func openNumber() {
        // TODO: - Open Coordinator
    }
}
