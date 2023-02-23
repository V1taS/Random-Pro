//
//  ColorsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import ColorsScreenModule

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
    let colorsScreenModule = ColorsScreenAssembly().createModule(permissionService: services.permissionService)
    self.colorsScreenModule = colorsScreenModule
    self.colorsScreenModule?.moduleOutput = self
    navigationController.pushViewController(colorsScreenModule, animated: true)
  }
}

// MARK: - ColorsScreenModuleOutput

extension ColorsScreenCoordinator: ColorsScreenModuleOutput {
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
    
    colorsScreenModule?.present(activityViewController, animated: true, completion: nil)
    
    // TODO: - 🔴
//    services.metricsService.track(event: .shareColors)
  }
}

// MARK: - Appearance

private extension ColorsScreenCoordinator {
  struct Appearance {
    let allowAccessToGallery = NSLocalizedString("Разрешить доступ к галерее", comment: "")
  }
}
