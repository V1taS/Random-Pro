//
//  ShareScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ShareScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ShareScreenCoordinatorInput {
  
  /// Обновить контент
  ///  - Parameter imageData: Изображение контента
  func updateContentWith(imageData: Data?)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ShareScreenCoordinatorOutput? { get set }
}

typealias ShareScreenCoordinatorProtocol = ShareScreenCoordinatorInput & Coordinator

final class ShareScreenCoordinator: ShareScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ShareScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var shareScreenModule: ShareScreenModule?
  
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
    let shareScreenModule = ShareScreenAssembly().createModule(permissionService: services.permissionService)
    self.shareScreenModule = shareScreenModule
    self.shareScreenModule?.moduleOutput = self
    let navController = UINavigationController(rootViewController: shareScreenModule)
    navigationController.present(navController, animated: true)
  }
  
  func updateContentWith(imageData: Data?) {
    shareScreenModule?.updateContentWith(imageData: imageData)
  }
}

// MARK: - ShareScreenModuleOutput

extension ShareScreenCoordinator: ShareScreenModuleOutput {
  func requestPhotosError() {
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
    activityViewController.popoverPresentationController?.sourceView = shareScreenModule?.view
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
        popup.sourceView = shareScreenModule?.view
        popup.sourceRect = CGRect(x: (shareScreenModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (shareScreenModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }
    
    shareScreenModule?.present(activityViewController, animated: true, completion: nil)
    services.metricsService.track(event: .shareImage)
  }
  
  func closeButtonAction() {
    navigationController.dismiss(animated: true)
  }
}

// MARK: - Appearance

private extension ShareScreenCoordinator {
  struct Appearance {
    let allowAccessToGallery = RandomStrings.Localizable.allowGalleryAccess
  }
}
