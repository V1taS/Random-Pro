//
//  ColorsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ColorsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ColorsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ColorsScreenCoordinatorOutput? { get set }
}

typealias ColorsScreenCoordinatorProtocol = ColorsScreenCoordinatorInput & Coordinator

final class ColorsScreenCoordinator: ColorsScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  var finishFlow: (() -> Void)?
  weak var output: ColorsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var colorsScreenModule: ColorsScreenModule?
  
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
    let colorsScreenModule = ColorsScreenAssembly().createModule(services: services)
    self.colorsScreenModule = colorsScreenModule
    self.colorsScreenModule?.moduleOutput = self
    navigationController.pushViewController(colorsScreenModule, animated: true)
  }
}

// MARK: - ColorsScreenModuleOutput

extension ColorsScreenCoordinator: ColorsScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func requestGalleryError() {
    services.notificationService.showNegativeAlertWith(
      title: Appearance().allowAccessToGallery,
      glyph: false,
      timeout: nil,
      active: {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
          return
        }
        UIApplication.shared.open(settingsUrl)
      }
    )
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func shareButtonAction(imageData: Data?) {
    guard
      let imageData = imageData,
      let imageFile = services.fileManagerService.saveObjectWith(fileName: "Random",
                                                                 fileExtension: ".png",
                                                                 data: imageData)
    else {
      return
    }
    
    let activityViewController = UIActivityViewController(activityItems: [imageFile],
                                                          applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = colorsScreenModule?.view
    activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop,
                                                    UIActivity.ActivityType.postToFacebook,
                                                    UIActivity.ActivityType.message,
                                                    UIActivity.ActivityType.addToReadingList,
                                                    UIActivity.ActivityType.assignToContact,
                                                    UIActivity.ActivityType.copyToPasteboard,
                                                    UIActivity.ActivityType.markupAsPDF,
                                                    UIActivity.ActivityType.openInIBooks,
                                                    UIActivity.ActivityType.postToFlickr,
                                                    UIActivity.ActivityType.postToTencentWeibo,
                                                    UIActivity.ActivityType.postToTwitter,
                                                    UIActivity.ActivityType.postToVimeo,
                                                    UIActivity.ActivityType.postToWeibo,
                                                    UIActivity.ActivityType.print]
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      if let popup = activityViewController.popoverPresentationController {
        popup.sourceView = colorsScreenModule?.view
        popup.sourceRect = CGRect(x: (colorsScreenModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (colorsScreenModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }
    
    colorsScreenModule?.present(activityViewController, animated: true)
  }
}

// MARK: - Appearance

private extension ColorsScreenCoordinator {
  struct Appearance {
    let allowAccessToGallery = RandomStrings.Localizable.allowGalleryAccess
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
