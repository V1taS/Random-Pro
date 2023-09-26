//
//  CoinStyleSelectionScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CoinStyleSelectionScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CoinStyleSelectionScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CoinStyleSelectionScreenCoordinatorOutput? { get set }
}

/// Псевдоним протокола Coordinator & CoinStyleSelectionScreenCoordinatorInput
typealias CoinStyleSelectionScreenCoordinatorProtocol = Coordinator & CoinStyleSelectionScreenCoordinatorInput

// MARK: - CoinStyleSelectionScreenCoordinator

/// Координатор `CoinStyleSelectionScreen`
final class CoinStyleSelectionScreenCoordinator: CoinStyleSelectionScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: CoinStyleSelectionScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private var module: CoinStyleSelectionScreenModule?
  private var navigationController: UINavigationController
  private let services: ApplicationServices
  
  // MARK: - Initialisation
  
  /// Ининциализатор
  /// - Parameters:
  ///   - navigationController: Навигейшн контроллер
  ///   - services: Сервисы приложения
  init(_ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Life cycle
  
  func start() {
    let module = CoinStyleSelectionScreenAssembly().createModule(services: services)
    self.module = module
    self.module?.moduleOutput = self
    navigationController.pushViewController(module, animated: true)
  }
}

// MARK: - CoinStyleSelectionScreenModuleOutput

extension CoinStyleSelectionScreenCoordinator: CoinStyleSelectionScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
}
