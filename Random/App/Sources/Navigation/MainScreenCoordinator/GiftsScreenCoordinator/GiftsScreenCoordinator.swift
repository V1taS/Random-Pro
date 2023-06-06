//
//  GiftsScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol GiftsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol GiftsScreenCoordinatorInput {

  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: GiftsScreenCoordinatorOutput? { get set }
}

typealias GiftsScreenCoordinatorProtocol = GiftsScreenCoordinatorInput & Coordinator

final class GiftsScreenCoordinator: GiftsScreenCoordinatorProtocol {

  // MARK: - Internal variables

  weak var output: GiftsScreenCoordinatorOutput?

  // MARK: - Private property

  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var giftsScreenModule: GiftsScreenModule?
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
    var giftsScreenModule = GiftsScreenAssembly().createModule(services: services)
    self.giftsScreenModule = giftsScreenModule
    giftsScreenModule.moduleOutput = self
    navigationController.pushViewController(giftsScreenModule, animated: true)
  }
}

// MARK: - GiftsScreenModuleOutput

extension GiftsScreenCoordinator: GiftsScreenModuleOutput {
  func settingButtonAction(model: GiftsScreenModel) {
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

extension GiftsScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}

  func cleanButtonAction() {
    giftsScreenModule?.cleanButtonAction()
  }

  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()

    listResultScreenCoordinator.setContentsFrom(list: giftsScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension GiftsScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Private

private extension GiftsScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = giftsScreenModule?.returnCurrentModel(),
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
      for: .gifts(
        itemsGenerated: "\(model.listResult.count)",
        lastItem: "\(model.result)",
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index),
                let country = LocaleType.init(rawValue: listCountry[index]) else {
            return
          }

          let language: GiftsScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }

          self?.giftsScreenModule?.setNewLanguage(language: language)
        }
      )
    )
  }
}

// MARK: - Appearance

private extension GiftsScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
