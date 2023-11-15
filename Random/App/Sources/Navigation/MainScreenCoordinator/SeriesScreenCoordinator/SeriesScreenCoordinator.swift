//
//  SeriesScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import UIKit
import SafariServices

/// Псевдоним протокола Coordinator & SeriesScreenCoordinatorInput
typealias SeriesScreenCoordinatorProtocol = Coordinator & SeriesScreenCoordinatorInput

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol SeriesScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol SeriesScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: SeriesScreenCoordinatorOutput? { get set }
}

// MARK: - SeriesScreenCoordinator

/// Координатор `SeriesScreen`
final class SeriesScreenCoordinator: SeriesScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: SeriesScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private var seriesScreenModule: SeriesScreenModule?
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
    let seriesScreenModule = SeriesScreenAssembly().createModule(services: services)
    self.seriesScreenModule = seriesScreenModule
    self.seriesScreenModule?.moduleOutput = self
    navigationController.pushViewController(seriesScreenModule, animated: true)
  }
}

// MARK: - SeriesScreenModuleOutput

extension SeriesScreenCoordinator: SeriesScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }

  func playTrailerActionWith(url: String) {
    guard let encodedTexts = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let seriesUrl = URL(string: encodedTexts) else {
      somethingWentWrong()
      return
    }

    let safariViewController = SFSafariViewController(url: seriesUrl)
    navigationController.present(safariViewController, animated: true, completion: nil)
  }

  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }

//  func resultLabelAction(text: String?) {
//    UIPasteboard.general.string = text
//    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
//                                                       glyph: true,
//                                                       timeout: nil,
//                                                       active: {})
//  }
}

// MARK: - Appearance

private extension SeriesScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  //  let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
