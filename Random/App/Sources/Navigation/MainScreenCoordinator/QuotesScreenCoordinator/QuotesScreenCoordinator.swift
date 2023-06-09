//
//  QuotesScreenCoordinator.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

final class QuotesScreenCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private var quotesScreenModule: QuotesScreenModule?
  
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
    var quotesScreenModule = QuotesScreenAssembly().createModule(services: services)
    self.quotesScreenModule = quotesScreenModule
    quotesScreenModule.moduleOutput = self
    navigationController.pushViewController(quotesScreenModule, animated: true)
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension QuotesScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    quotesScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(
      list: quotesScreenModule?.returnCurrentModel().listResult ?? []
    )
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension QuotesScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - QuotesScreenModuleOutput

extension QuotesScreenCoordinator: QuotesScreenModuleOutput {
  func settingButtonAction(model: QuoteScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
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

private extension QuotesScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = quotesScreenModule?.returnCurrentModel(),
          let language = model.language,
          let settingsScreenCoordinator else {
      return
    }
    
    let listCountry = [
      LocaleType.us.rawValue,
      LocaleType.ru.rawValue
    ]
    
    let currentCountry: String
    
    switch language {
    case .en:
      currentCountry = LocaleType.us.rawValue
    case .ru:
      currentCountry = LocaleType.ru.rawValue
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .quotes(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index),
                let country = LocaleType.init(rawValue: listCountry[index]) else {
            return
          }
          
          let language: QuoteScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          self?.quotesScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension QuotesScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
