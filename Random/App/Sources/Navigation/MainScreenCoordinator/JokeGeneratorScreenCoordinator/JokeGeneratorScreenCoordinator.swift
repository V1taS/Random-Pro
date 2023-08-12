//
//  JokeGeneratorScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

final class JokeGeneratorScreenCoordinator: Coordinator {

  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var jokeGeneratorScreenModule: JokeGeneratorScreenModule?
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
    var jokeGeneratorScreenModule = JokeGeneratorScreenAssembly().createModule(services)
    self.jokeGeneratorScreenModule = jokeGeneratorScreenModule
    jokeGeneratorScreenModule.moduleOutput = self
    navigationController.pushViewController(jokeGeneratorScreenModule, animated: true)
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension JokeGeneratorScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - SettingsScreenCoordinatorOutput

extension JokeGeneratorScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    jokeGeneratorScreenModule?.cleanButtonAction()
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
      list: jokeGeneratorScreenModule?.returnCurrentModel().listResult ?? []
    )
  }
}

// MARK: - JokeGeneratorScreenModuleOutput

extension JokeGeneratorScreenCoordinator: JokeGeneratorScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func settingButtonAction(model: JokeGeneratorScreenModel) {
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

private extension JokeGeneratorScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = jokeGeneratorScreenModule?.returnCurrentModel(),
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
      for: .joke(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index) else {
            return
          }
          
          let country = LanguageType.getTypeFrom(title: listCountry[index])
          let language: JokeGeneratorScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          self?.jokeGeneratorScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension JokeGeneratorScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
