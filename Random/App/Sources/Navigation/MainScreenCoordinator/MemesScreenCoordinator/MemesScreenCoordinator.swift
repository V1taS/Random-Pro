//
//  MemesScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

final class MemesScreenCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var memesScreenModule: MemesScreenModule?
  
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
    var memesScreenModule = MemesScreenAssembly().createModule(services)
    self.memesScreenModule = memesScreenModule
    memesScreenModule.moduleOutput = self
    navigationController.pushViewController(memesScreenModule, animated: true)
  }
}

// MARK: - QuotesScreenModuleOutput

extension MemesScreenCoordinator: MemesScreenModuleOutput {
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
    activityViewController.popoverPresentationController?.sourceView = memesScreenModule?.view
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
        popup.sourceView = memesScreenModule?.view
        popup.sourceRect = CGRect(x: (memesScreenModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (memesScreenModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }
    
    memesScreenModule?.present(activityViewController, animated: true, completion: nil)
  }
  
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - Private

private extension MemesScreenCoordinator {}

// MARK: - Appearance

private extension MemesScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
    let allowAccessToGallery = RandomStrings.Localizable.allowGalleryAccess
  }
}
