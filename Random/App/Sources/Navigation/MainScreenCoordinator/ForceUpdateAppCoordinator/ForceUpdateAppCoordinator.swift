//
//  ForceUpdateAppCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit

/// Псевдоним протокола Coordinator & ForceUpdateAppCoordinatorInput
typealias ForceUpdateAppCoordinatorProtocol = Coordinator & ForceUpdateAppCoordinatorInput

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ForceUpdateAppCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ForceUpdateAppCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ForceUpdateAppCoordinatorOutput? { get set }
}

// MARK: - ForceUpdateAppCoordinator

/// Координатор `ForceUpdateApp`
final class ForceUpdateAppCoordinator: ForceUpdateAppCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: ForceUpdateAppCoordinatorOutput?
  
  // MARK: - Private property
  
  private var module: ForceUpdateAppModule?
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
    let module = ForceUpdateAppAssembly().createModule(services: services)
    self.module = module
    self.module?.moduleOutput = self
    
    let newNavigationController = UINavigationController(rootViewController: module)
    self.newNavigationController = newNavigationController
    newNavigationController.modalPresentationStyle = .fullScreen
    navigationController.present(newNavigationController, animated: true)
  }
}

// MARK: - ForceUpdateAppModuleOutput

extension ForceUpdateAppCoordinator: ForceUpdateAppModuleOutput {
  func closeAction() {
    newNavigationController?.dismiss(animated: true)
  }
  
  func updateButtonAction() {
    guard let url = Appearance().shareAppUrl,
          UIApplication.shared.canOpenURL(url) else {
      return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
}

private extension ForceUpdateAppCoordinator {
  struct Appearance {
    let shareAppUrl = URL(string: "https://apps.apple.com/app/random-pro/id1552813956")
  }
}
