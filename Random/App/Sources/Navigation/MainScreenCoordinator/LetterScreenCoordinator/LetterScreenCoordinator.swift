//
//  LetterScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol LetterScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol LetterScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: LetterScreenCoordinatorOutput? { get set }
}

typealias LetterScreenCoordinatorProtocol = LetterScreenCoordinatorInput & Coordinator

final class LetterScreenCoordinator: LetterScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: LetterScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var letterScreenModule: LetterScreenModule?
  
  // Coordinators
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
  
  // MARK: - Internal property
  
  func start() {
    let letterScreenModule = LetterScreenAssembly().createModule(services: services)
    self.letterScreenModule = letterScreenModule
    self.letterScreenModule?.moduleOutput = self
    navigationController.pushViewController(letterScreenModule, animated: true)
  }
}

// MARK: - LetterScreenModuleOutput

extension LetterScreenCoordinator: LetterScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func cleanButtonWasSelected(model: LetterScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .letter(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: LetterScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .letter(
      withoutRepetition: model.isEnabledWithoutRepetition,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
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
    services.notificationService.showNeutralAlertWith(
      title: Appearance().lettersRangeEnded,
      glyph: true,
      timeout: nil,
      active: {}
    )
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension LetterScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
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

// MARK: - Appearance

private extension LetterScreenCoordinator {
  struct Appearance {
    let lettersRangeEnded = RandomStrings.Localizable.alphabetRangeEnded
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
