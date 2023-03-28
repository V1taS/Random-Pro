//
//  MainSettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import MessageUI
import RandomUIKit
import MainScreenModule
import AppPurchasesService
import StorageService
import NotificationService
import MetricsService
import YandexMobileMetrica
import FirebaseAnalytics

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainSettingsScreenCoordinatorOutput: AnyObject {
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func darkThemeChanged(_ isEnabled: Bool)
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainSettingsScreenCoordinatorInput {
  
  /// Обновить контент
  ///  - Parameter isDarkTheme: Темная тема
  func updateContentWith(isDarkTheme: Bool?)
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenModel.Section])
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: MainSettingsScreenCoordinatorOutput? { get set }
}

typealias MainSettingsScreenCoordinatorProtocol = MainSettingsScreenCoordinatorInput & Coordinator

final class MainSettingsScreenCoordinator: NSObject, MainSettingsScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: MainSettingsScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainSettingsScreenModule: MainSettingsScreenModule?
  private let window: UIWindow?
  private var modalNavigationController: UINavigationController?
  private var customMainSectionsCoordinator: CustomMainSectionsCoordinatorProtocol?
  private var cacheMainScreenSections: [MainScreenModel.Section] = []
  private var anyCoordinator: Coordinator?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - navigationController: UINavigationController
  init(_ window: UIWindow?,
       _ navigationController: UINavigationController) {
    self.window = window
    self.navigationController = navigationController
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
  func applicationIconSectionsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let selecteAppIconScreenCoordinator = SelecteAppIconScreenCoordinator(upperViewController)
    anyCoordinator = selecteAppIconScreenCoordinator
    selecteAppIconScreenCoordinator.output = self
    selecteAppIconScreenCoordinator.start()
    track(event: .selecteAppIcon)
  }
  
  func premiumSectionsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let premiumScreenCoordinator = PremiumScreenCoordinator(upperViewController)
    anyCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.push)
    premiumScreenCoordinator.start()
    track(event: .premiumScreen)
  }
  
  func feedBackButtonAction() {
    let appearance = Appearance()
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      let identifierForVendor = "\(appearance.identifierForVendor): \(UIDevice.current.identifierForVendor?.uuidString ?? "")"
      let systemVersion = "\(appearance.systemVersion): iOS \(UIDevice.current.systemVersion)"
      let appVersion = "\(appearance.appVersion): \(Bundle.main.appVersionLong)"
      let messageBody = """


      \(identifierForVendor)
      \(systemVersion)
      \(appVersion)
"""
      
      mail.mailComposeDelegate = self
      mail.setToRecipients([appearance.addressRecipients])
      mail.setSubject(appearance.subjectRecipients)
      mail.setMessageBody(messageBody, isHTML: false)
      mainSettingsScreenModule?.present(mail, animated: true)
    } else {
      notificationService.showNegativeAlertWith(title: appearance.emailClientNotFound,
                                                glyph: false,
                                                timeout: nil,
                                                active: {})
    }
    track(event: .feedBack)
  }
  
  func customMainSectionsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let customMainSectionsCoordinator = CustomMainSectionsCoordinator(upperViewController)
    self.customMainSectionsCoordinator = customMainSectionsCoordinator
    customMainSectionsCoordinator.output = self
    customMainSectionsCoordinator.start()
    
    customMainSectionsCoordinator.updateContentWith(models: cacheMainScreenSections)
    track(event: .customMainSections)
  }
  
  func darkThemeChanged(_ isEnabled: Bool) {
    window?.overrideUserInterfaceStyle = isEnabled ? .dark : .light
    output?.darkThemeChanged(isEnabled)
  }
  
  func closeButtonAction() {
    navigationController.dismiss(animated: true)
  }
}

// MARK: - PremiumScreenCoordinatorOutput

extension MainSettingsScreenCoordinator: PremiumScreenCoordinatorOutput {
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - CustomMainSectionsCoordinatorOutput

extension MainSettingsScreenCoordinator: CustomMainSectionsCoordinatorOutput {
  func didChanged(models: [MainScreenModel.Section]) {
    output?.didChanged(models: models)
    cacheMainScreenSections = models
  }
}

// MARK: - MFMailComposeViewControllerDelegate

extension MainSettingsScreenCoordinator: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult,
                             error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}

// MARK: - SelecteAppIconScreenCoordinatorOutput

extension MainSettingsScreenCoordinator: SelecteAppIconScreenCoordinatorOutput {}

// MARK: - Private

private extension MainSettingsScreenCoordinator {
  func track(event: MetricsSections) {
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsSections, properties: [String: String]) {
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}

// MARK: - Appearance

private extension MainSettingsScreenCoordinator {
  struct Appearance {
    let addressRecipients = "Random_Pro_support@iCloud.com"
    let subjectRecipients = NSLocalizedString("Поддержка приложения Random Pro", comment: "")
    let identifierForVendor = NSLocalizedString("Идентификатор поставщика", comment: "")
    let systemVersion = NSLocalizedString("Версия системы", comment: "")
    let appVersion = NSLocalizedString("Версия приложения", comment: "")
    let emailClientNotFound = NSLocalizedString("Почтовый клиент не найден", comment: "")
  }
}
