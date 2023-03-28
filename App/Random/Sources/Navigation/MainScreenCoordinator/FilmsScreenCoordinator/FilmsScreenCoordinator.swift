//
//  FilmsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FilmsScreenModule
import NotificationService
import StorageService

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
  private var filmsScreenModule: FilmsScreenModule?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let filmsScreenModule = FilmsScreenAssembly().createModule(storageService: StorageServiceImpl())
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
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                              glyph: false,
                                              timeout: nil,
                                              active: {})
  }
}

// MARK: - Adapter StorageService

extension StorageServiceImpl: FilmsScreenStorageServiceProtocol {}

// MARK: - Appearance

private extension FilmsScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
  }
}
