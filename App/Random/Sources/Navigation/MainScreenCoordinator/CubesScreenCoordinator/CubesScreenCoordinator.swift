//
//  CubesScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import CubesScreenModule
import StorageService
import NotificationService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CubesScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CubesScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CubesScreenCoordinatorOutput? { get set }
}

typealias CubesScreenCoordinatorProtocol = CubesScreenCoordinatorInput & Coordinator

final class CubesScreenCoordinator: CubesScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: CubesScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var cubesScreenModule: CubesScreenModule?
  private let notificationService = NotificationServiceImpl()
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    var cubesScreenModule = CubesScreenAssembly().createModule(storageService: StorageServiceImpl())
    self.cubesScreenModule = cubesScreenModule
    cubesScreenModule.moduleOutput = self
    navigationController.pushViewController(cubesScreenModule, animated: true)
  }
}

// MARK: - CubesScreenModuleOutput

extension CubesScreenCoordinator: CubesScreenModuleOutput {
  func cleanButtonWasSelected() {
    let model = cubesScreenModule?.returnCurrentModel()
    settingsScreenCoordinator?.setupDefaultsSettings(for: .cube(isShowlistGenerated: model?.isShowlistGenerated ?? true,
                                                                itemsGenerated: "\(model?.listResult.count ?? .zero)",
                                                                lastItem: "\(model?.listResult.last ?? "")"))
  }
  
  func settingButtonAction(model: CubesScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .cube(isShowlistGenerated: model.isShowlistGenerated,
                                                               itemsGenerated: "\(model.listResult.count)",
                                                               lastItem: "\(model.listResult.last ?? "")"))
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension CubesScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
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
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: cubesScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension CubesScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Adapter StorageService

extension StorageServiceImpl: CubesScreenStorageServiceProtocol {}

// MARK: - Appearance

private extension CubesScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
