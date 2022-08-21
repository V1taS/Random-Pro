//
//  SettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

protocol SettingsScreenCoordinatorOutput: AnyObject {
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, кнопка `Список` была нажата
  func listOfObjectsAction()
}

protocol SettingsScreenCoordinatorInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter typeObject: Тип отображаемого контента
  func setupDefaultsSettings(for typeObject: SettingsScreenType)
  
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
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
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

// MARK: - SettingsScreenCoordinatorInput

extension SettingsScreenCoordinator {
  func setupDefaultsSettings(for typeObject: SettingsScreenType) {
    settingsScreenModule?.setupDefaultsSettings(for: typeObject)
  }
}

// MARK: - SettingsScreenModuleOutput

extension SettingsScreenCoordinator: SettingsScreenModuleOutput {
  func listOfObjectsAction() {
    output?.listOfObjectsAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    output?.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    output?.cleanButtonAction()
  }
}
