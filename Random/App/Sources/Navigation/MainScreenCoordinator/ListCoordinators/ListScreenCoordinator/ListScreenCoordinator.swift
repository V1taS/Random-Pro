//
//  ListScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ListScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ListScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ListScreenCoordinatorOutput? { get set }
}

typealias ListScreenCoordinatorProtocol = ListScreenCoordinatorInput & Coordinator

final class ListScreenCoordinator: ListScreenCoordinatorProtocol {

  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: ListScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var listScreenModule: ListScreenModule?
  
  // Coordinators
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private var listAddItemsScreenCoordinator: ListAddItemsScreenCoordinatorProtocol?
  private var fortuneWheelSelectedSectionCoordinator: FortuneWheelSelectedSectionCoordinator?
  
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
    var listScreenModule = ListScreenAssembly().createModule(services: services)
    self.listScreenModule = listScreenModule
    listScreenModule.moduleOutput = self
    navigationController.pushViewController(listScreenModule, animated: true)
  }
}

// MARK: - ListScreenModuleOutput

extension ListScreenCoordinator: ListScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func cleanButtonWasSelected() {
    updateSettingsScreenContent()
  }
  
  func didReceiveError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func didReceiveIsEmptyError() {
    services.notificationService.showNeutralAlertWith(title: Appearance().listElementsIsEmpty,
                                                      glyph: true,
                                                      timeout: nil,
                                                      active: {})
  }
  
  func didReceiveRangeUniqueItemsError() {
    services.notificationService.showNeutralAlertWith(title: Appearance().uniqueElementsIsOver,
                                                      glyph: true,
                                                      timeout: nil,
                                                      active: {})
  }
  
  func resultCopied(text: String?) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func settingButtonAction() {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    updateSettingsScreenContent()
  }
}

// MARK: - FortuneWheelSelectedSectionCoordinatorOutput

extension ListScreenCoordinator: FortuneWheelSelectedSectionCoordinatorOutput {
  func didReceiveNew(model: FortuneWheelModel) {
    let models: [ListScreenModel.Section] = model.sections.compactMap {
      let objects = $0.objects.compactMap({
        ListScreenModel.TextModel(id: $0.id, text: $0.text)
      })
      return ListScreenModel.Section(
        isSelected: $0.isSelected,
        title: $0.title,
        icon: $0.icon,
        objects: objects
      )
    }
    listScreenModule?.updateContentWith(models: models)
    updateSettingsScreenContent()
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension ListScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    listScreenModule?.updateWithoutRepetition(isOn)
  }
  
  func cleanButtonAction() {
    listScreenModule?.cleanButtonAction()
  }
  
  func createListAction() {
    let fortuneWheelSelectedSectionCoordinator = FortuneWheelSelectedSectionCoordinator(navigationController, services)
    self.fortuneWheelSelectedSectionCoordinator = fortuneWheelSelectedSectionCoordinator
    self.fortuneWheelSelectedSectionCoordinator?.output = self
    fortuneWheelSelectedSectionCoordinator.isPushViewController = true
    self.fortuneWheelSelectedSectionCoordinator?.start()
    fortuneWheelSelectedSectionCoordinator.finishFlow = { [weak self] in
      self?.fortuneWheelSelectedSectionCoordinator = nil
    }
    
    guard let model = listScreenModule?.returnCurrentModel() else {
      return
    }
    
    let sections: [FortuneWheelModel.Section] = model.allItems.compactMap {
      let objects: [FortuneWheelModel.TextModel] = $0.objects.compactMap {
        FortuneWheelModel.TextModel(id: $0.id, text: $0.text)
      }
      return FortuneWheelModel.Section(
        isSelected: $0.isSelected,
        title: $0.title,
        icon: $0.icon,
        objects: objects
      )
    }
    fortuneWheelSelectedSectionCoordinator.setDefault(
      model: .init(
        result: nil,
        listResult: [],
        style: .regular,
        sections: sections,
        isEnabledFeedback: false
      )
    )
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    let model = listScreenModule?.returnCurrentModel()
    listResultScreenCoordinator.setContentsFrom(list: model?.generetionItems ?? [])
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
      allTextCount: "\(model.allItems.filter({$0.isSelected}).first?.objects.count ?? .zero)",
      lastItem: "\(model.generetionItems.last ?? "?")"
    ))
  }
}

// MARK: - Appearance

private extension ListScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let listElementsIsEmpty = RandomStrings.Localizable.listOfElementsEmpty
    let uniqueElementsIsOver = RandomStrings.Localizable.listOfUniqueElementsEnded
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
