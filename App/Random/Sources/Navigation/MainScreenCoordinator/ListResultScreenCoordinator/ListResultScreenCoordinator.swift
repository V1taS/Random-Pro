//
//  ListResultScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit
import ListResultScreenModule
import NotificationService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ListResultScreenCoordinatorOutput: AnyObject { }

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ListResultScreenCoordinatorInput {
  
  /// Установить список результатов
  ///  - Parameter list: Список результатов
  func setContentsFrom(list: [String])
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ListResultScreenCoordinatorOutput? { get set }
}

typealias ListResultScreenCoordinatorProtocol = ListResultScreenCoordinatorInput & Coordinator

final class ListResultScreenCoordinator: ListResultScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ListResultScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var listResultScreenModule: ListResultScreenModule?
  private var shareScreenCoordinator: ShareScreenCoordinatorProtocol?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
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
  func shareButtonAction(imageData: Data?) {
    let shareScreenCoordinator = ShareScreenCoordinator(navigationController)
    self.shareScreenCoordinator = shareScreenCoordinator
    self.shareScreenCoordinator?.output = self
    shareScreenCoordinator.start()
    
    self.shareScreenCoordinator?.updateContentWith(imageData: imageData)
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

// MARK: - ShareScreenCoordinatorOutput

extension ListResultScreenCoordinator: ShareScreenCoordinatorOutput {}

// MARK: - Appearance

private extension ListResultScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
