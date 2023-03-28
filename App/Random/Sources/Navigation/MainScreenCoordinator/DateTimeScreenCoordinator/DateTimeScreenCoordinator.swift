//
//  DateTimeScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import DateTimeScreenModule
import NotificationService
import StorageService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol DateTimeScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol DateTimeScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: DateTimeScreenCoordinatorOutput? { get set }
}

typealias DateTimeScreenCoordinatorProtocol = DateTimeScreenCoordinatorInput & Coordinator

final class DateTimeScreenCoordinator: DateTimeScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: DateTimeScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var dateTimeScreenModule: DateTimeModule?
  private let notificationService = NotificationServiceImpl()
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let dateTimeScreenModule = DateTimeAssembly().createModule(storageService: StorageServiceImpl())
    self.dateTimeScreenModule = dateTimeScreenModule
    self.dateTimeScreenModule?.moduleOutput = self
    navigationController.pushViewController(dateTimeScreenModule, animated: true)
  }
}

// MARK: - DateTimeModuleOutput

extension DateTimeScreenCoordinator: DateTimeModuleOutput {
  func resultLabelAction(model: DateTimeScreenModel) {
    UIPasteboard.general.string = model.result
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func cleanButtonWasSelected(model: DateTimeScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .dateAndTime(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: DateTimeScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .dateAndTime(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension DateTimeScreenCoordinator: SettingsScreenCoordinatorOutput {
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
    
    listResultScreenCoordinator.setContentsFrom(list: dateTimeScreenModule?.returnListResult() ?? [])
  }
  
  func cleanButtonAction() {
    dateTimeScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
}

// MARK: - ListResultScreenCoordinatorOutput

extension DateTimeScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Adapter StorageService

extension StorageServiceImpl: DateTimeScreenStorageServiceProtocol {}

// MARK: - Appearance

private extension DateTimeScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
