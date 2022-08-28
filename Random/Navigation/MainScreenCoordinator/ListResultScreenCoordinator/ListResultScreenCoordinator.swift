//
//  ListResultScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

protocol ListResultScreenCoordinatorOutput: AnyObject { }

protocol ListResultScreenCoordinatorInput {
  
  /// Установить список результатов
  ///  - Parameter list: Список результатов
  func setContentsFrom(list: [String])
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: ListResultScreenCoordinatorOutput? { get set }
}

typealias ListResultScreenCoordinatorProtocol = ListResultScreenCoordinatorInput & Coordinator

final class ListResultScreenCoordinator: ListResultScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ListResultScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var listResultScreenModule: ListResultScreenModule?
  
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
    let listResultScreenModule = ListResultScreenAssembly().createModule()
    self.listResultScreenModule = listResultScreenModule
    self.listResultScreenModule?.moduleOutput = self
    navigationController.pushViewController(listResultScreenModule, animated: true)
  }
  
  func setContentsFrom(list: [String]) {
    listResultScreenModule?.setContentsFrom(list: list)
  }
}

// MARK: - ListResultScreenModuleOutput

extension ListResultScreenCoordinator: ListResultScreenModuleOutput {
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true)
  }
}

// MARK: - Appearance

private extension ListResultScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
