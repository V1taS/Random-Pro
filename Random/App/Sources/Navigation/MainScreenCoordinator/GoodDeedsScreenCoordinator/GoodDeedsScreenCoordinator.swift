//
//  GoodDeedsScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//

import UIKit
import RandomUIKit

final class GoodDeedsScreenCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var goodDeedsScreenModule: GoodDeedsScreenModule?
  private let services: ApplicationServices
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
    var goodDeedsScreenModule = GoodDeedsScreenAssembly().createModule(services: services)
    self.goodDeedsScreenModule = goodDeedsScreenModule
    goodDeedsScreenModule.moduleOutput = self
    navigationController.pushViewController(goodDeedsScreenModule, animated: true)
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension GoodDeedsScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    goodDeedsScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(
      list: goodDeedsScreenModule?.returnCurrentModel().listResult ?? []
    )
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension GoodDeedsScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - GoodDeedsScreenModuleOutput

extension GoodDeedsScreenCoordinator: GoodDeedsScreenModuleOutput {
  func settingButtonAction(model: GoodDeedsScreenModel) {
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

private extension GoodDeedsScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = goodDeedsScreenModule?.returnCurrentModel(),
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
      for: .goodDeedsS(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index),
                let country = LocaleType.init(rawValue: listCountry[index]) else {
            return
          }
          
          let language: GoodDeedsScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          self?.goodDeedsScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension GoodDeedsScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
