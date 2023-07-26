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
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  
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
  func settingButtonAction(model: MemesScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    setupDefaultsSettings()
  }
  
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

// MARK: - SettingsScreenCoordinatorOutput

extension MemesScreenCoordinator: SettingsScreenCoordinatorOutput {
  func cleanButtonAction() {}
  func listOfObjectsAction() {}
}

// MARK: - Private

private extension MemesScreenCoordinator {
  func setupDefaultsSettings() {
    guard let model = memesScreenModule?.returnCurrentModel(),
          let language = model.language,
          let settingsScreenCoordinator else {
      return
    }
    
    let listCountry = [
      LanguageType.us.title,
      LanguageType.ru.title
    ]
    
    let currentCountry: String
    
    switch language {
    case .en:
      currentCountry = LanguageType.us.title
    case .ru:
      currentCountry = LanguageType.ru.title
    }
    
    var types = model.types
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .memes(
        currentCountry: currentCountry,
        listOfItems: listCountry,
        valueChanged: { [weak self] index in
          guard listCountry.indices.contains(index) else {
            return
          }
          
          let country = LanguageType.getTypeFrom(title: listCountry[index])
          let language: MemesScreenModel.Language
          switch country {
          case .ru:
            language = .ru
          default:
            language = .en
          }
          self?.memesScreenModule?.setNewLanguage(language: language)
        },
        work: (
          MemesScreenModel.MemesType.work.title,
          types.contains(.work), { [weak self] isEnabledWork in
            if isEnabledWork, !types.contains(.work) {
              types.append(.work)
              self?.memesScreenModule?.updateMemes(type: types)
              return
            }
            
            if !isEnabledWork,
               types.contains(.work),
               let index = types.firstIndex(of: .work) {
              types.remove(at: index)
              self?.memesScreenModule?.updateMemes(type: types)
            }
          }
        ),
        animals: (
          MemesScreenModel.MemesType.animals.title,
          types.contains(.animals), { [weak self] isEnabledWork in
            if isEnabledWork, !types.contains(.animals) {
              types.append(.animals)
              self?.memesScreenModule?.updateMemes(type: types)
              return
            }
            
            if !isEnabledWork,
               types.contains(.animals),
               let index = types.firstIndex(of: .animals) {
              types.remove(at: index)
              self?.memesScreenModule?.updateMemes(type: types)
            }
          }
        ),
        popular: (
          MemesScreenModel.MemesType.popular.title,
          types.contains(.popular), { [weak self] isEnabledWork in
            if isEnabledWork, !types.contains(.popular) {
              types.append(.popular)
              self?.memesScreenModule?.updateMemes(type: types)
              return
            }
            
            if !isEnabledWork,
               types.contains(.popular),
               let index = types.firstIndex(of: .popular) {
              types.remove(at: index)
              self?.memesScreenModule?.updateMemes(type: types)
            }
          }
        )
      )
    )
  }
}

// MARK: - Appearance

private extension MemesScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
    let allowAccessToGallery = RandomStrings.Localizable.allowGalleryAccess
  }
}
