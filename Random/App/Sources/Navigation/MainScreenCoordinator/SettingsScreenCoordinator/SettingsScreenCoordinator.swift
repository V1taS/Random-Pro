//
//  SettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol SettingsScreenCoordinatorOutput: AnyObject {
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, кнопка `Список` была нажата
  func listOfObjectsAction()
  
  /// Событие, кнопка `Создать список` была нажата
  func createListAction()
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// Расширение протокола
extension SettingsScreenCoordinatorOutput {
  func createListAction() {}
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol SettingsScreenCoordinatorInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter typeObject: Тип отображаемого контента
  func setupDefaultsSettings(for typeObject: SettingsScreenType)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: SettingsScreenCoordinatorOutput? { get set }
}

typealias SettingsScreenCoordinatorProtocol = SettingsScreenCoordinatorInput & Coordinator

final class SettingsScreenCoordinator: SettingsScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  var finishFlow: (() -> Void)?
  weak var output: SettingsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var settingsScreenModule: SettingsScreenModule?
  
  // Coordinators
  private var playerCardSelectionScreenCoordinator: PlayerCardSelectionScreenCoordinator?
  
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
  func moduleClosed() {
    finishFlow?()
  }
  
  func playerCardSelectionAction() {
    openPlayerCardSelectionScreenCoordinator()
  }
  
  func createListAction() {
    output?.createListAction()
  }
  
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

// MARK: - PlayerCardSelectionScreenCoordinatorOutput

extension SettingsScreenCoordinator: PlayerCardSelectionScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Private

private extension SettingsScreenCoordinator {
  func openPlayerCardSelectionScreenCoordinator() {
    let playerCardSelectionScreenCoordinator = PlayerCardSelectionScreenCoordinator(navigationController,
                                                                                    services)
    self.playerCardSelectionScreenCoordinator = playerCardSelectionScreenCoordinator
    playerCardSelectionScreenCoordinator.output = self
    playerCardSelectionScreenCoordinator.start()
    playerCardSelectionScreenCoordinator.finishFlow = { [weak self] in
      self?.playerCardSelectionScreenCoordinator = nil
    }
    
    services.metricsService.track(event: .premiumPlayerCardSelection)
  }
}

// MARK: - Appearance

private extension SettingsScreenCoordinator {
  struct Appearance {}
}
