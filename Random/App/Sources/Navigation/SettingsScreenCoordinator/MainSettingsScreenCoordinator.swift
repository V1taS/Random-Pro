//
//  MainSettingsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import MessageUI
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainSettingsScreenCoordinatorOutput: AnyObject {
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func applyDarkTheme(_ isEnabled: Bool?)
  
  /// Премиум режим включен
  /// - Parameter isEnabled: Премиум режим включен
  func applyPremium(_ isEnabled: Bool)
  
  /// Данные были изменены
  ///  - Parameter models: результат генерации
  func didChanged(models: [MainScreenModel.Section])
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainSettingsScreenCoordinatorInput {
  
  /// Обновить контент
  ///  - Parameter model: Модель данных
  func updateContentWith(model: MainSettingsScreenModel)
  
  /// Обновить контент
  /// - Parameter models: Моделька секций
  func updateContentWith(models: [MainScreenModel.Section])
  
  /// Запустить диплинк
  func startDeepLink()
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: MainSettingsScreenCoordinatorOutput? { get set }
}

typealias MainSettingsScreenCoordinatorProtocol = MainSettingsScreenCoordinatorInput & Coordinator

final class MainSettingsScreenCoordinator: NSObject, MainSettingsScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: MainSettingsScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainSettingsScreenModule: MainSettingsScreenModule?
  private let services: ApplicationServices
  private let window: UIWindow?
  private var modalNavigationController: UINavigationController?
  private var cacheMainScreenSections: [MainScreenModel.Section] = []
  
  // Coordinators
  private var customMainSectionsCoordinator: CustomMainSectionsCoordinatorProtocol?
  private var premiumWithFriendsCoordinator: PremiumWithFriendsCoordinator?
  private var selecteAppIconScreenCoordinator: SelecteAppIconScreenCoordinator?
  private var premiumScreenCoordinator: PremiumScreenCoordinator?
  
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
    let mainSettingsScreenModule = MainSettingsScreenAssembly().createModule(services: services)
    self.mainSettingsScreenModule = mainSettingsScreenModule
    self.mainSettingsScreenModule?.moduleOutput = self
    
    let modalNavigationController = UINavigationController(rootViewController: mainSettingsScreenModule)
    self.modalNavigationController = modalNavigationController
    navigationController.present(modalNavigationController, animated: true)
  }
  
  func updateContentWith(model: MainSettingsScreenModel) {
    mainSettingsScreenModule?.updateContentWith(model: model)
  }
  
  func updateContentWith(models: [MainScreenModel.Section]) {
    cacheMainScreenSections = models
  }
  
  func startDeepLink() {
    guard let deepLinkType = services.deepLinkService.deepLinkType else {
      return
    }
    
    switch deepLinkType {
    case .settingsSections:
      customMainSectionsSelected()
    case .settingsIconSelection:
      applicationIconSectionsSelected()
    case .settingsPremiumSection:
      premiumSectionsSelected()
    case .settingsShareApp:
      shareButtonSelected()
    case .settingsfeedBackButton:
      feedBackButtonAction()
    default:
      break
    }
    
    var deepLinkService: DeepLinkService = services.deepLinkService
    deepLinkService.deepLinkType = nil
    services.metricsService.track(event: .deepLinks,
                                  properties: ["screen": deepLinkType.deepLinkEndPoint])
  }
}

// MARK: - MainSettingsScreenModuleOutput

extension MainSettingsScreenCoordinator: MainSettingsScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func premiumWithFriendsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let premiumWithFriendsCoordinator = PremiumWithFriendsCoordinator(upperViewController, services)
    self.premiumWithFriendsCoordinator = premiumWithFriendsCoordinator
    premiumWithFriendsCoordinator.output = self
    premiumWithFriendsCoordinator.selectPresentType(.push)
    premiumWithFriendsCoordinator.start()
    premiumWithFriendsCoordinator.finishFlow = { [weak self] in
      self?.premiumWithFriendsCoordinator = nil
    }
    
    services.metricsService.track(event: .premiumWithFriends)
  }
  
  func shareButtonSelected() {
    let appearance = Appearance()
    guard let url = appearance.shareAppUrl else {
      return
    }

    let objectsToShare = [url]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

    if UIDevice.current.userInterfaceIdiom == .pad {
      if let popup = activityVC.popoverPresentationController {
        popup.sourceView = mainSettingsScreenModule?.view
        popup.sourceRect = CGRect(x: (mainSettingsScreenModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (mainSettingsScreenModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }

    mainSettingsScreenModule?.present(activityVC, animated: true, completion: nil)
    services.metricsService.track(event: .shareApp)
  }

  func applyPremium(_ isEnabled: Bool) {
    output?.applyPremium(isEnabled)
  }
  
  func applicationIconSectionsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let selecteAppIconScreenCoordinator = SelecteAppIconScreenCoordinator(upperViewController,
                                                                          services)
    self.selecteAppIconScreenCoordinator = selecteAppIconScreenCoordinator
    selecteAppIconScreenCoordinator.output = self
    selecteAppIconScreenCoordinator.start()
    selecteAppIconScreenCoordinator.finishFlow = { [weak self] in
      self?.selecteAppIconScreenCoordinator = nil
    }
    
    services.metricsService.track(event: .selecteAppIcon)
  }
  
  func premiumSectionsSelected() {
    guard let upperViewController = modalNavigationController else {
      return
    }
    
    let premiumScreenCoordinator = PremiumScreenCoordinator(upperViewController,
                                                            services)
    self.premiumScreenCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.push)
    premiumScreenCoordinator.start()
    premiumScreenCoordinator.finishFlow = { [weak self] in
      self?.premiumScreenCoordinator = nil
    }
    
    services.metricsService.track(event: .premiumScreen)
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
      services.notificationService.showNegativeAlertWith(title: appearance.emailClientNotFound,
                                                         glyph: false,
                                                         timeout: nil,
                                                         active: {})
    }
    services.metricsService.track(event: .feedBack)
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
    customMainSectionsCoordinator.finishFlow = { [weak self] in
      self?.customMainSectionsCoordinator = nil
    }
    
    customMainSectionsCoordinator.updateContentWith(models: cacheMainScreenSections)
    services.metricsService.track(event: .customMainSections)
  }
  
  func applyDarkTheme(_ isEnabled: Bool?) {
    switch isEnabled {
    case nil:
      window?.overrideUserInterfaceStyle = .unspecified
    case false:
      window?.overrideUserInterfaceStyle = .light
    default:
      window?.overrideUserInterfaceStyle = .dark
    }
    
    output?.applyDarkTheme(isEnabled)
  }
  
  func closeButtonAction() {
    navigationController.dismiss(animated: true)
  }
}

// MARK: - PremiumScreenCoordinatorOutput

extension MainSettingsScreenCoordinator: PremiumScreenCoordinatorOutput {
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

// MARK: - Appearance

private extension MainSettingsScreenCoordinator {
  struct Appearance {
    let addressRecipients = "Random_Pro_support@iCloud.com"
    let subjectRecipients = RandomStrings.Localizable.randomProAppSupport
    let identifierForVendor = RandomStrings.Localizable.vendorIdentifier
    let systemVersion = RandomStrings.Localizable.systemVersion
    let appVersion = RandomStrings.Localizable.appVersion
    let emailClientNotFound = RandomStrings.Localizable.emailClientNotFound
    let shareAppUrl = URL(string: "https://apps.apple.com/app/random-pro/id1552813956")
  }
}
