//
//  SlogansScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

final class SlogansScreenCoordinator: Coordinator {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var slogansScreenModule: SlogansScreenModule?
  private let services: ApplicationServices
  
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
  
  // MARK: - Internal func
  
  func start() {
    var slogansScreenModule = SlogansScreenAssembly().createModule(services)
    self.slogansScreenModule = slogansScreenModule
    slogansScreenModule.moduleOutput = self
    navigationController.pushViewController(slogansScreenModule, animated: true)
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension SlogansScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - SettingsScreenCoordinatorOutput

extension SlogansScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    slogansScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    listResultScreenCoordinator.setContentsFrom(
      list: slogansScreenModule?.returnCurrentModel().listResult ?? []
    )
  }
}

// MARK: - SlogansScreenModuleOutput

extension SlogansScreenCoordinator: SlogansScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func settingButtonAction(model: SlogansScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    setupDefaultsSettings()
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func cleanButtonWasSelected() {
    setupDefaultsSettings()
  }
}

// MARK: - Private

private extension SlogansScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = slogansScreenModule?.returnCurrentModel(),
          let language = model.language,
          let settingsScreenCoordinator else {
      return
    }
    
    let listCountry = [
      LanguageType.us.title,
      LanguageType.ru.title
    ]
    
    let currentCountry: String
    
    switch language {
    case .en:
      currentCountry = LanguageType.us.title
    case .ru:
      currentCountry = LanguageType.ru.title
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .slogans(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index) else {
            return
          }
          
          let country = LanguageType.getTypeFrom(title: listCountry[index])
          let language: SlogansScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          self?.slogansScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension SlogansScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
