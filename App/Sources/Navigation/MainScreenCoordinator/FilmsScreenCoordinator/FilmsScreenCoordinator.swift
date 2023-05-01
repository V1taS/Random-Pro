//
//  FilmsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol FilmsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol FilmsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: FilmsScreenCoordinatorOutput? { get set }
}

typealias FilmsScreenCoordinatorProtocol = FilmsScreenCoordinatorInput & Coordinator

final class FilmsScreenCoordinator: FilmsScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: FilmsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var filmsScreenModule: FilmsScreenModule?
  
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
    let filmsScreenModule = FilmsScreenAssembly().createModule(services: services)
    self.filmsScreenModule = filmsScreenModule
    self.filmsScreenModule?.moduleOutput = self
    navigationController.pushViewController(filmsScreenModule, animated: true)
  }
}

// MARK: - FilmsScreenModuleOutput

extension FilmsScreenCoordinator: FilmsScreenModuleOutput {
  func playTrailerActionWith(url: String) {
    guard let encodedTexts = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let filmUrl = URL(string: encodedTexts) else {
      somethingWentWrong()
      return
    }
    UIApplication.shared.open(filmUrl)
  }
  
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func resultLabelAction(text: String?) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - Appearance

private extension FilmsScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
