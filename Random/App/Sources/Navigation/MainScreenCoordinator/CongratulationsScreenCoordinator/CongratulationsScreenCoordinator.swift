//
//  CongratulationsScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CongratulationsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CongratulationsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CongratulationsScreenCoordinatorOutput? { get set }
}

typealias CongratulationsScreenCoordinatorProtocol = CongratulationsScreenCoordinatorInput & Coordinator

final class CongratulationsScreenCoordinator: CongratulationsScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: CongratulationsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var congratulationsScreenModule: CongratulationsScreenModule?
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
    var congratulationsScreenModule = CongratulationsScreenAssembly().createModule(services: services)
    self.congratulationsScreenModule = congratulationsScreenModule
    congratulationsScreenModule.moduleOutput = self
    navigationController.pushViewController(congratulationsScreenModule, animated: true)
  }
}

// MARK: - CongratulationsScreenModuleOutput

extension CongratulationsScreenCoordinator: CongratulationsScreenModuleOutput {
  func settingButtonAction(model: CongratulationsScreenModel) {
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

// MARK: - SettingsScreenCoordinatorOutput

extension CongratulationsScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    congratulationsScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(
      list: congratulationsScreenModule?.returnCurrentModel().listResult ?? []
    )
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension CongratulationsScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Private

private extension CongratulationsScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = congratulationsScreenModule?.returnCurrentModel(),
          let language = model.language,
          let settingsScreenCoordinator else {
      return
    }
    
    let listCountry = LocaleType.allCases.compactMap { $0.rawValue }
    let currentCountry: String
    
    switch language {
    case .en:
      currentCountry = LocaleType.us.rawValue
    default:
      currentCountry = language.rawValue
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .congratulations(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          let listCountry = LocaleType.allCases.compactMap { $0.rawValue }
          guard listCountry.indices.contains(index),
                let country = LocaleType.init(rawValue: listCountry[index]) else {
            return
          }
          
          let language: CongratulationsScreenModel.Language
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
          
          self?.congratulationsScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension CongratulationsScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
