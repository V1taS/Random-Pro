//
//  RiddlesScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol RiddlesScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol RiddlesScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: RiddlesScreenCoordinatorOutput? { get set }
}

typealias RiddlesScreenCoordinatorProtocol = RiddlesScreenCoordinatorInput & Coordinator

final class RiddlesScreenCoordinator: RiddlesScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: RiddlesScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var riddlesScreenModule: RiddlesScreenModule?
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
    var riddlesScreenModule = RiddlesScreenAssembly().createModule(services)
    self.riddlesScreenModule = riddlesScreenModule
    riddlesScreenModule.moduleOutput = self
    navigationController.pushViewController(riddlesScreenModule, animated: true)
  }
}

// MARK: - RiddlesScreenModuleOutput

extension RiddlesScreenCoordinator: RiddlesScreenModuleOutput {
  func infoButtonAction(text: String) {
    showAlerWith(title: Appearance().answer, description: text)
  }
  
  func settingButtonAction(model: RiddlesScreenModel) {
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

// MARK: - ListResultScreenCoordinatorOutput

extension RiddlesScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - SettingsScreenCoordinatorOutput

extension RiddlesScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    riddlesScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    let listResult = riddlesScreenModule?.returnCurrentModel().listResult.compactMap {
      return "\($0.question)\n\n\(RandomStrings.Localizable.answer): \($0.answer)"
    }
    
    listResultScreenCoordinator.setContentsFrom(
      list: listResult ?? []
    )
  }
}

// MARK: - Private

private extension RiddlesScreenCoordinator {
  func showAlerWith(title: String, description: String) {
    let appearance = Appearance()
    let alert = UIAlertController(title: title,
                                  message: description,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: appearance.ok,
                                  style: .cancel,
                                  handler: { _ in }))
    riddlesScreenModule?.present(alert, animated: true, completion: nil)
  }
  
  func setupDefaultsSettings() {
    guard let model = riddlesScreenModule?.returnCurrentModel(),
          let language = model.language,
          let settingsScreenCoordinator else {
      return
    }
    
    let listCountry = [
      CountryType.us.rawValue,
      CountryType.ru.rawValue
    ]
    
    let currentCountry: String
    
    switch language {
    case .en:
      currentCountry = CountryType.us.rawValue
    case .ru:
      currentCountry = CountryType.ru.rawValue
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .riddles(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index),
                let country = CountryType.init(rawValue: listCountry[index]) else {
            return
          }
          
          let language: RiddlesScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          self?.riddlesScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension RiddlesScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
    let cancel = RandomStrings.Localizable.cancel
    let ok = RandomStrings.Localizable.ok
    let answer = RandomStrings.Localizable.answer
  }
}
