//
//  NumberScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import NumberScreenModule
import NotificationService
import StorageService

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
  private var numberScreenModule: NumberScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let numberScreenModule = NumberScreenAssembly().createModule(storageService: StorageServiceImpl())
    self.numberScreenModule = numberScreenModule
    self.numberScreenModule?.moduleOutput = self
    navigationController.pushViewController(numberScreenModule, animated: true)
  }
}

// MARK: - NumberScreenModuleOutput

extension NumberScreenCoordinator: NumberScreenModuleOutput {
  func didReceiveRangeError() {
    notificationService.showNegativeAlertWith(title: Appearance().numberRangeError,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func resultLabelAction(text: String?) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func didReceiveRangeEnded() {
    notificationService.showNeutralAlertWith(title: Appearance().numberRangeEnded,
                                             glyph: true,
                                             timeout: nil,
                                             active: {})
  }
  
  func cleanButtonWasSelected(model: NumberScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .number(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: NumberScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
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
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
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

// MARK: - Adapter StorageService

extension StorageServiceImpl: NumberScreenStorageServiceProtocol {}

// MARK: - Appearance

private extension NumberScreenCoordinator {
  struct Appearance {
    let numberRangeEnded = NSLocalizedString("Диапазон чисел закончился", comment: "")
    let numberRangeError = NSLocalizedString("Неверно задан диапазон", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
