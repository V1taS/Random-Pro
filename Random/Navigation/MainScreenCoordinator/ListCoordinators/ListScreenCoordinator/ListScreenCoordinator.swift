//
//  ListScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol ListScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol ListScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: ListScreenCoordinatorOutput? { get set }
}

typealias ListScreenCoordinatorProtocol = ListScreenCoordinatorInput & Coordinator

final class ListScreenCoordinator: ListScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: ListScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var listScreenModule: ListScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private var listAddItemsScreenCoordinator: ListAddItemsScreenCoordinatorProtocol?
  
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
    var listScreenModule = ListScreenAssembly().createModule()
    self.listScreenModule = listScreenModule
    listScreenModule.moduleOutput = self
    navigationController.pushViewController(listScreenModule, animated: true)
  }
}

// MARK: - ListScreenModuleOutput

extension ListScreenCoordinator: ListScreenModuleOutput {
  func cleanButtonWasSelected() {
    updateSettingsScreenContent()
  }
  
  func didReceiveError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: true,
                                                       active: {})
  }
  
  func didReceiveIsEmptyError() {
    services.notificationService.showNeutralAlertWith(title: Appearance().listElementsIsEmpty,
                                                      glyph: true,
                                                      active: {})
  }
  
  func didReceiveRangeUniqueItemsError() {
    services.notificationService.showNeutralAlertWith(title: Appearance().uniqueElementsIsOver,
                                                      glyph: true,
                                                      active: {})
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       active: {})
  }
  
  func settingButtonAction() {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    updateSettingsScreenContent()
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension ListScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {
    listScreenModule?.updateWithoutRepetition(isOn)
  }
  
  func cleanButtonAction() {
    listScreenModule?.cleanButtonAction()
  }
  
  func createListAction() {
    let listAddItemsScreenCoordinator = ListAddItemsScreenCoordinator(navigationController)
    self.listAddItemsScreenCoordinator = listAddItemsScreenCoordinator
    self.listAddItemsScreenCoordinator?.output = self
    self.listAddItemsScreenCoordinator?.start()
    
    guard let model = listScreenModule?.returnCurrentModel() else {
      return
    }
    let models = model.allItems.map {
      return ListAddItemsScreenModel.TextModel(id: $0.id, text: $0.text)
    }
    listAddItemsScreenCoordinator.updateContentWith(models: models)
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    let model = listScreenModule?.returnCurrentModel()
    listResultScreenCoordinator.setContentsFrom(list: model?.generetionItems ?? [])
  }
}

// MARK: - ListAddItemsScreenCoordinatorOutput

extension ListScreenCoordinator: ListAddItemsScreenCoordinatorOutput {
  func didReceiveText(models: [ListAddItemsScreenModel.TextModel]) {
    let models = models.map {
      return ListScreenModel.TextModel(id: $0.id, text: $0.text)
    }
    listScreenModule?.updateContentWith(models: models)
    
    updateSettingsScreenContent()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension ListScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Private

private extension ListScreenCoordinator {
  func updateSettingsScreenContent() {
    guard let model = listScreenModule?.returnCurrentModel() else {
      return
    }
    
    settingsScreenCoordinator?.setupDefaultsSettings(for: .list(
      withoutRepetition: model.withoutRepetition,
      generatedTextCount: "\(model.generetionItems.count)",
      allTextCount: "\(model.allItems.count)",
      lastItem: "\(model.generetionItems.last ?? "?")"
    ))
  }
}

// MARK: - Appearance

private extension ListScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
    let listElementsIsEmpty = NSLocalizedString("Список элементов пуст", comment: "")
    let uniqueElementsIsOver = NSLocalizedString("Список уникальных элементов закончился", comment: "")
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
  }
}
