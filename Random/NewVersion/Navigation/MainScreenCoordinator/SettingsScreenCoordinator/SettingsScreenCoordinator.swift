//
//  SettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

protocol SettingsScreenCoordinatorOutput: AnyObject {
  
}

protocol SettingsScreenCoordinatorInput: AnyObject {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: SettingsScreenCoordinatorOutput? { get set }
}

typealias SettingsScreenCoordinatorProtocol = SettingsScreenCoordinatorInput & Coordinator

final class SettingsScreenCoordinator: SettingsScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: SettingsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var settingsScreenModule: SettingsScreenModule?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let settingsScreenModule = SettingsScreenAssembly().createModule()
    
    self.settingsScreenModule = settingsScreenModule
    self.settingsScreenModule?.moduleOutput = self
    navigationController.pushViewController(settingsScreenModule, animated: true)
  }
}

// MARK: - SettingsScreenModuleOutput

extension SettingsScreenCoordinator: SettingsScreenModuleOutput {
  func withoutRepetitionAction(model: SettingsScreenModel) {
    
  }
  
  func listOfNumbersAction(numbers: [String]) {
    
  }
  
  func cleanButtonAction() {
    
  }
}
