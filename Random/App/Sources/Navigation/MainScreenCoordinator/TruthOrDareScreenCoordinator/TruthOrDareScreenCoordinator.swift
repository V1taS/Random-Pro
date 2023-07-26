//
//  TruthOrDareScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol TruthOrDareScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol TruthOrDareScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: TruthOrDareScreenCoordinatorOutput? { get set }
}

typealias TruthOrDareScreenCoordinatorProtocol = TruthOrDareScreenCoordinatorInput & Coordinator

final class TruthOrDareScreenCoordinator: TruthOrDareScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: TruthOrDareScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var truthOrDareScreenModule: TruthOrDareScreenModule?
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
    var truthOrDareScreenModule = TruthOrDareScreenAssembly().createModule(services: services)
    self.truthOrDareScreenModule = truthOrDareScreenModule
    truthOrDareScreenModule.moduleOutput = self
    navigationController.pushViewController(truthOrDareScreenModule, animated: true)
  }
}

// MARK: - TruthOrDareScreenModuleOutput

extension TruthOrDareScreenCoordinator: TruthOrDareScreenModuleOutput {
  func settingButtonAction(model: TruthOrDareScreenModel) {
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

extension TruthOrDareScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    truthOrDareScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: truthOrDareScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension TruthOrDareScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Private

private extension TruthOrDareScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = truthOrDareScreenModule?.returnCurrentModel(),
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
      for: .truthOrDare(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index) else {
            return
          }
          
          let country = LanguageType.getTypeFrom(title: listCountry[index])
          let language: TruthOrDareScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          
          self?.truthOrDareScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension TruthOrDareScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
