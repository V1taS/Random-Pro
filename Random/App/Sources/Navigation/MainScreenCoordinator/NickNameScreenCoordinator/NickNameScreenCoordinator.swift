//
//  NickNameScreenCoordinator.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol NickNameScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol NickNameScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: NickNameScreenCoordinatorOutput? { get set }
}

typealias NickNameScreenCoordinatorProtocol = NickNameScreenCoordinatorInput & Coordinator

final class NickNameScreenCoordinator: NickNameScreenCoordinatorProtocol {
  
  weak var output: NickNameScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var nickNameScreenModule: NickNameScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  
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
  
  func start() {
    var nickNameScreenModule = NickNameScreenAssembly().createModule(services: services)
    
    self.nickNameScreenModule = nickNameScreenModule
    nickNameScreenModule.moduleOutput = self
    navigationController.pushViewController(nickNameScreenModule, animated: true)
  }
}

// MARK: - NickNameScreenModuleOutput

extension NickNameScreenCoordinator: NickNameScreenModuleOutput {
  func cleanButtonWasSelected() {}
  
  func settingButtonAction(model: NickNameScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .nickname(result: model.result,
                                                                   indexSegmented: model.indexSegmented))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension NickNameScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  
  func cleanButtonAction() {}
  
  func listOfObjectsAction() {}
  
  func updateStateForSections() {}
}
