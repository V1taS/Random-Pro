//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// Псевдоним для координатора. Первый параметр `Input`, второй `CallBackTypeObject`
///  По умолчанию `<Void, Void>`
typealias MainScreenCoordinatorProtocol = Coordinator<Void, Void>

final class MainScreenCoordinator: MainScreenCoordinatorProtocol {
    
    // MARK: - Private variables
    
    private let navigationController: UINavigationController
    private var mainScreenModule: MainScreenModule?
    private let services: ApplicationServices
    private var numberScreenCoordinator: NumberScreenCoordinatorProtocol?
    
    // MARK: - Initialization
    
    /// - Parameters:
    ///   - navigationController: UINavigationController
    ///   - services: Сервисы приложения
    init(_ navigationController: UINavigationController,
         _ services: ApplicationServices) {
        self.navigationController = navigationController
        self.services = services
    }
    
    // MARK: - Internal func
    
    override func start(parameter: Void) {
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
        let numberScreenCoordinator = NumberScreenCoordinator(navigationController: navigationController,
                                                              services: services)
        self.numberScreenCoordinator = numberScreenCoordinator
        numberScreenCoordinator.start()
    }
}
