//
//  NamesScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol NamesScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol NamesScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: NamesScreenCoordinatorOutput? { get set }
}

typealias NamesScreenCoordinatorProtocol = NamesScreenCoordinatorInput & Coordinator

final class NamesScreenCoordinator: NamesScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: NamesScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var namesScreenModule: NamesScreenModule?
  
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
    navigationController.pushViewController(NamesNewScreenAssembly().createModule().viewController, animated: true)
//    var namesScreenModule = NamesScreenAssembly().createModule(services: services)
//    self.namesScreenModule = namesScreenModule
//    namesScreenModule.moduleOutput = self
//    navigationController.pushViewController(namesScreenModule, animated: true)
  }
}

// MARK: - NamesScreenModuleOutput

extension NamesScreenCoordinator: NamesScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func settingButtonAction(model: NamesScreenModel) {
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

// MARK: - SettingsScreenCoordinatorOutput

extension NamesScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    namesScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    listResultScreenCoordinator.setContentsFrom(list: namesScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension NamesScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Private

private extension NamesScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = namesScreenModule?.returnCurrentModel(),
          let language = model.language,
          let settingsScreenCoordinator else {
      return
    }
    
    let listCountry = LanguageType.allCases.compactMap { $0.title }
    let currentCountry: String
    
    switch language {
    case .en:
      currentCountry = LanguageType.us.title
    case .de:
      currentCountry = LanguageType.de.title
    case .it:
      currentCountry = LanguageType.it.title
    case .ru:
      currentCountry = LanguageType.ru.title
    case .es:
      currentCountry = LanguageType.es.title
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .names(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          let listCountry = CountryType.allCases.compactMap { $0.title }
          guard listCountry.indices.contains(index) else {
            return
          }
          
          let country = LanguageType.getTypeFrom(title: listCountry[index])
          let language: NamesScreenModel.Language
          switch country {
          case .de:
            language = .de
          case .us:
            language = .en
          case .it:
            language = .it
          case .ru:
            language = .ru
          case .es:
            language = .es
          }
          
          self?.namesScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension NamesScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
