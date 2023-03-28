//
//  SettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit
import SettingsScreenModule
import YandexMobileMetrica
import FirebaseAnalytics
import MetricsService

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
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
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
  
  weak var output: SettingsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var settingsScreenModule: SettingsScreenModule?
  private var anyCoordinator: Coordinator?
  
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

// MARK: - SettingsScreenCoordinatorOutput

extension SettingsScreenCoordinatorOutput {
  func createListAction() {}
}

// MARK: - SettingsScreenModuleOutput

extension SettingsScreenCoordinator: SettingsScreenModuleOutput {
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
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Private

private extension SettingsScreenCoordinator {
  func openPlayerCardSelectionScreenCoordinator() {
    let playerCardSelectionScreenCoordinator = PlayerCardSelectionScreenCoordinator(navigationController)
    anyCoordinator = playerCardSelectionScreenCoordinator
    playerCardSelectionScreenCoordinator.output = self
    playerCardSelectionScreenCoordinator.start()
    
    track(event: .premiumPlayerCardSelection)
  }
}

// MARK: - Private

private extension SettingsScreenCoordinator {
  func track(event: MetricsSections) {
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsSections, properties: [String: String]) {
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}

// MARK: - Appearance

private extension SettingsScreenCoordinator {
  struct Appearance {}
}
