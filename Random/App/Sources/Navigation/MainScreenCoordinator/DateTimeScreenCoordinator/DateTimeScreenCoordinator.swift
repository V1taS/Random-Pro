//
//  DateTimeScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol DateTimeScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
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
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private let services: ApplicationServices
  
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
    let dateTimeScreenModule = DateTimeAssembly().createModule(services: services)
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
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
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
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
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
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
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

// MARK: - Appearance

private extension DateTimeScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
