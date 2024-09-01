//
//  AppUnavailableCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit
import MessageUI

/// Псевдоним протокола Coordinator & AppUnavailableCoordinatorInput
typealias AppUnavailableCoordinatorProtocol = Coordinator & AppUnavailableCoordinatorInput

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol AppUnavailableCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol AppUnavailableCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: AppUnavailableCoordinatorOutput? { get set }
}

// MARK: - AppUnavailableCoordinator

/// Координатор `AppUnavailable`
final class AppUnavailableCoordinator: NSObject, AppUnavailableCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: AppUnavailableCoordinatorOutput?
  
  // MARK: - Private property
  
  private var module: AppUnavailableModule?
  private var navigationController: UINavigationController
  private var newNavigationController: UINavigationController?
  private let services: ApplicationServices
  
  // MARK: - Initialisation
  
  /// Ининциализатор
  /// - Parameters:
  ///   - navigationController: Навигейшн контроллер
  ///   - services: Сервисы приложения
  init(navigationController: UINavigationController,
       services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Life cycle
  
  func start() {
    let module = AppUnavailableAssembly().createModule(services: services)
    self.module = module
    self.module?.moduleOutput = self
    
    let newNavigationController = UINavigationController(rootViewController: module)
    self.newNavigationController = newNavigationController
    newNavigationController.modalPresentationStyle = .fullScreen
    navigationController.present(newNavigationController, animated: true)
  }
}

// MARK: - AppUnavailableModuleOutput

extension AppUnavailableCoordinator: AppUnavailableModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func closeModuleAction() {
    newNavigationController?.dismiss(animated: true)
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
      mail.setToRecipients([SecretsAPI.supportMail])
      mail.setSubject(appearance.subjectRecipients)
      mail.setMessageBody(messageBody, isHTML: false)
      module?.present(mail, animated: true)
    } else {
      services.notificationService.showNegativeAlertWith(title: appearance.emailClientNotFound,
                                                         glyph: false,
                                                         timeout: nil,
                                                         active: {})
    }
    services.metricsService.track(event: .feedBack)
  }
}

// MARK: - MFMailComposeViewControllerDelegate

extension AppUnavailableCoordinator: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController,
                             didFinishWith result: MFMailComposeResult,
                             error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}

// MARK: - Appearance

private extension AppUnavailableCoordinator {
  struct Appearance {
    let subjectRecipients = RandomStrings.Localizable.randomProAppSupport
    let identifierForVendor = RandomStrings.Localizable.vendorIdentifier
    let systemVersion = RandomStrings.Localizable.systemVersion
    let appVersion = RandomStrings.Localizable.appVersion
    let emailClientNotFound = RandomStrings.Localizable.emailClientNotFound
    let shareAppUrl = URL(string: "https://apps.apple.com/app/random-pro/id1552813956")
  }
}
