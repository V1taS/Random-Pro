//
//  LetterScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import LetterScreenModule
import StorageService
import NotificationService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol LetterScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol LetterScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: LetterScreenCoordinatorOutput? { get set }
}

typealias LetterScreenCoordinatorProtocol = LetterScreenCoordinatorInput & Coordinator

final class LetterScreenCoordinator: LetterScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: LetterScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var letterScreenModule: LetterScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal property
  
  func start() {
    let letterScreenModule = LetterScreenAssembly().createModule(storageService: StorageServiceImpl())
    self.letterScreenModule = letterScreenModule
    self.letterScreenModule?.moduleOutput = self
    navigationController.pushViewController(letterScreenModule, animated: true)
  }
}

// MARK: - LetterScreenModuleOutput

extension LetterScreenCoordinator: LetterScreenModuleOutput {
  func cleanButtonWasSelected(model: LetterScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .letter(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: LetterScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .letter(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func didReceiveRangeEnded() {
    notificationService.showNeutralAlertWith(
      title: Appearance().lettersRangeEnded,
      glyph: true,
      timeout: nil,
      active: {}
    )
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension LetterScreenCoordinator: SettingsScreenCoordinatorOutput {
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
    
    listResultScreenCoordinator.setContentsFrom(list: letterScreenModule?.returnListResult() ?? [])
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    letterScreenModule?.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    letterScreenModule?.cleanButtonAction()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension LetterScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Adapter StorageService

extension StorageServiceImpl: LetterScreenStorageServiceProtocol {}

// MARK: - Appearance

private extension LetterScreenCoordinator {
  struct Appearance {
    let lettersRangeEnded = NSLocalizedString("Диапазон букв закончился", comment: "")
  }
}
