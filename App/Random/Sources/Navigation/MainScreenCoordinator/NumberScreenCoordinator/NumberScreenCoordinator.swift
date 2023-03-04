//
//  NumberScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import NumberScreenModule

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol NumberScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol NumberScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: NumberScreenCoordinatorOutput? { get set }
}

typealias NumberScreenCoordinatorProtocol = NumberScreenCoordinatorInput & Coordinator

final class NumberScreenCoordinator: NumberScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: NumberScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var numberScreenModule: NumberScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
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
    let numberScreenModule = NumberScreenAssembly().createModule(storageService: services.storageService)
    self.numberScreenModule = numberScreenModule
    self.numberScreenModule?.moduleOutput = self
    navigationController.pushViewController(numberScreenModule, animated: true)
  }
}

// MARK: - NumberScreenModuleOutput

extension NumberScreenCoordinator: NumberScreenModuleOutput {
  func didReceiveRangeError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().numberRangeError,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func resultLabelAction(text: String?) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func didReceiveRangeEnded() {
    services.notificationService.showNeutralAlertWith(title: Appearance().numberRangeEnded,
                                                      glyph: true,
                                                      timeout: nil,
                                                      active: {})
  }
  
  func cleanButtonWasSelected(model: NumberScreenModelProtocol) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .number(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: NumberScreenModelProtocol) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .number(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension NumberScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: numberScreenModule?.returnListResult() ?? [])
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    numberScreenModule?.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    numberScreenModule?.cleanButtonAction()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension NumberScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension NumberScreenCoordinator {
  struct Appearance {
    let numberRangeEnded = NSLocalizedString("Диапазон чисел закончился", comment: "")
    let numberRangeError = NSLocalizedString("Неверно задан диапазон", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
