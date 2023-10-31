//
//  CubesScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CubesScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CubesScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CubesScreenCoordinatorOutput? { get set }
}

typealias CubesScreenCoordinatorProtocol = CubesScreenCoordinatorInput & Coordinator

final class CubesScreenCoordinator: CubesScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: CubesScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var cubesScreenModule: CubesScreenModule?
  
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
    var cubesScreenModule = CubesScreenAssembly().createModule(services: services)
    self.cubesScreenModule = cubesScreenModule
    cubesScreenModule.moduleOutput = self
    navigationController.pushViewController(cubesScreenModule, animated: true)
  }
}

// MARK: - CubesScreenModuleOutput

extension CubesScreenCoordinator: CubesScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func cleanButtonWasSelected() {
    let model = cubesScreenModule?.returnCurrentModel()
    settingsScreenCoordinator?.setupDefaultsSettings(for: .cube(isShowlistGenerated: model?.isShowlistGenerated ?? true,
                                                                itemsGenerated: "\(model?.listResult.count ?? .zero)",
                                                                lastItem: "\(model?.listResult.last ?? "")"))
  }
  
  func settingButtonAction(model: CubesScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .cube(isShowlistGenerated: model.isShowlistGenerated,
                                                               itemsGenerated: "\(model.listResult.count)",
                                                               lastItem: "\(model.listResult.last ?? "")"))
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension CubesScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    cubesScreenModule?.listGenerated(isShow: isOn)
  }
  
  func cleanButtonAction() {
    cubesScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    listResultScreenCoordinator.setContentsFrom(list: cubesScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension CubesScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension CubesScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
