//
//  PremiumWithFriendsCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 24.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PremiumWithFriendsCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PremiumWithFriendsCoordinatorInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter type: Тип показа
  func selectPresentType(_ type: PremiumWithFriendsCoordinator.PremiumScreenPresentType)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: PremiumScreenCoordinatorOutput? { get set }
}

typealias PremiumWithFriendsCoordinatorProtocol = PremiumWithFriendsCoordinatorInput & Coordinator

final class PremiumWithFriendsCoordinator: PremiumWithFriendsCoordinatorProtocol {
  
  enum PremiumScreenPresentType {
    
    /// Модальный показ
    case present
    
    /// Стандартный в навигейшен стеке
    case push
  }
  
  // MARK: - Internal property
  
  weak var output: PremiumScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var premiumWithFriendsModule: PremiumWithFriendsModule?
  private var presentType: PremiumScreenPresentType?
  private var premiumScreenNavigationController: UINavigationController?
  
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
  
  func selectPresentType(_ type: PremiumScreenPresentType) {
    presentType = type
  }
  
  func start() {
    guard let presentType else {
      return
    }
    
    let premiumWithFriendsModule = PremiumWithFriendsAssembly().createModule(services: services)
    self.premiumWithFriendsModule = premiumWithFriendsModule
    self.premiumWithFriendsModule?.moduleOutput = self
    premiumWithFriendsModule.selectIsModalPresentationStyle(presentType == .present)
    
    if presentType == .present {
      let premiumScreenNavigationController = UINavigationController(rootViewController: premiumWithFriendsModule)
      self.premiumScreenNavigationController = premiumScreenNavigationController
      premiumScreenNavigationController.modalPresentationStyle = .fullScreen
      navigationController.present(premiumScreenNavigationController, animated: true)
    } else {
      navigationController.pushViewController(premiumWithFriendsModule, animated: true)
    }
  }
}

// MARK: - PremiumWithFriendsModuleOutput

extension PremiumWithFriendsCoordinator: PremiumWithFriendsModuleOutput {
  func copyLinkAction(_ link: String?) {
    guard let link, let url = URL(string: link) else {
      return
    }
    
    let objectsToShare = [url]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      if let popup = activityVC.popoverPresentationController {
        popup.sourceView = premiumWithFriendsModule?.view
        popup.sourceRect = CGRect(x: (premiumWithFriendsModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (premiumWithFriendsModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }
    
    premiumWithFriendsModule?.present(activityVC, animated: true, completion: nil)
    services.metricsService.track(event: .premiumWithFriends)
  }
  
  func closeButtonAction() {
    premiumScreenNavigationController?.dismiss(animated: true)
  }
}

// MARK: - Appearance

private extension PremiumWithFriendsCoordinator {
  struct Appearance {
    let somethingWentWrongTitle = RandomStrings.Localizable.somethingWentWrong
    let premiumAccessActivatedTitle = RandomStrings.Localizable.premiumAccessActivated
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
