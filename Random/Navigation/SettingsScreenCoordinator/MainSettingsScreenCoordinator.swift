//
//  MainSettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol MainSettingsScreenCoordinatorOutput: AnyObject {
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func darkThemeChanged(_ isEnabled: Bool)
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol MainSettingsScreenCoordinatorInput {
  
  /// Обновить контент
  ///  - Parameter isDarkTheme: Темная тема
  func updateContentWith(isDarkTheme: Bool?)
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenModel.Section])
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: MainSettingsScreenCoordinatorOutput? { get set }
}

typealias MainSettingsScreenCoordinatorProtocol = MainSettingsScreenCoordinatorInput & Coordinator

final class MainSettingsScreenCoordinator: MainSettingsScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: MainSettingsScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainSettingsScreenModule: MainSettingsScreenModule?
  private let services: ApplicationServices
  private let window: UIWindow?
  private var modalNavigationController: UINavigationController?
  private var customMainSectionsCoordinator: CustomMainSectionsCoordinatorProtocol?
  private var cacheMainScreenSections: [MainScreenModel.Section] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - navigationController: UINavigationController
  ///   - services: Сервисы приложения
  init(_ window: UIWindow?,
       _ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.window = window
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainSettingsScreenModule = MainSettingsScreenAssembly().createModule()
    self.mainSettingsScreenModule = mainSettingsScreenModule
    self.mainSettingsScreenModule?.moduleOutput = self
    
    let modalNavigationController = UINavigationController(rootViewController: mainSettingsScreenModule)
    self.modalNavigationController = modalNavigationController
    navigationController.present(modalNavigationController, animated: true)
  }
  
  func updateContentWith(isDarkTheme: Bool?) {
    mainSettingsScreenModule?.updateContentWith(isDarkTheme: isDarkTheme)
  }
  
  func updateContentWith(models: [MainScreenModel.Section]) {
    cacheMainScreenSections = models
  }
}

// MARK: - MainSettingsScreenModuleOutput

extension MainSettingsScreenCoordinator: MainSettingsScreenModuleOutput {
  func feedBackButtonAction() {
    guard let settingsUrl = URL(string: Appearance().telegramURL) else {
      return
    }
    UIApplication.shared.open(settingsUrl)
    services.metricsService.track(event: .feedBackTG)
  }
  
  func customMainSectionsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let customMainSectionsCoordinator = CustomMainSectionsCoordinator(upperViewController,
                                                                      services)
    self.customMainSectionsCoordinator = customMainSectionsCoordinator
    customMainSectionsCoordinator.output = self
    customMainSectionsCoordinator.start()
    
    customMainSectionsCoordinator.updateContentWith(models: cacheMainScreenSections)
    services.metricsService.track(event: .customMainSections)
  }
  
  func darkThemeChanged(_ isEnabled: Bool) {
    window?.overrideUserInterfaceStyle = isEnabled ? .dark : .light
    output?.darkThemeChanged(isEnabled)
  }
  
  func closeButtonAction() {
    navigationController.dismiss(animated: true)
  }
}

// MARK: - CustomMainSectionsCoordinatorOutput

extension MainSettingsScreenCoordinator: CustomMainSectionsCoordinatorOutput {
  func didChanged(models: [MainScreenModel.Section]) {
    output?.didChanged(models: models)
    cacheMainScreenSections = models
  }
}

// MARK: - Appearance

private extension MainSettingsScreenCoordinator {
  struct Appearance {
    let telegramURL = "https://t.me/V1taS"
  }
}
