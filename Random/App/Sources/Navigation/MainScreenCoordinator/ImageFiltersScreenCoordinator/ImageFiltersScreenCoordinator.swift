//
//  ImageFiltersScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import MobileCoreServices
import PhotosUI

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ImageFiltersScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ImageFiltersScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ImageFiltersScreenCoordinatorOutput? { get set }
}

typealias ImageFiltersScreenCoordinatorProtocol = ImageFiltersScreenCoordinatorInput & Coordinator

final class ImageFiltersScreenCoordinator: NSObject, ImageFiltersScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ImageFiltersScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var imageFiltersScreenModule: ImageFiltersScreenModule?
  
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
    let imageFiltersScreenModule = ImageFiltersScreenAssembly().createModule(services: services)
    self.imageFiltersScreenModule = imageFiltersScreenModule
    self.imageFiltersScreenModule?.moduleOutput = self
    navigationController.pushViewController(imageFiltersScreenModule, animated: true)
  }
}

// MARK: - ColorsScreenModuleOutput

extension ImageFiltersScreenCoordinator: ImageFiltersScreenModuleOutput {
  func didReceiveError() {
    services.notificationService.showNegativeAlertWith(
      title: Appearance().failedSomeError,
      glyph: false,
      timeout: nil,
      active: {}
    )
  }
  
  func chooseImageButtonAction() {
    openImageFiltersActionSheet()
  }
  
  func requestGalleryActionSheetSuccess() {
    openGalleryModule()
  }
  
  func requestCameraActionSheetSuccess() {
    openCameraModule()
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
    activityViewController.popoverPresentationController?.sourceView = imageFiltersScreenModule?.view
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
        popup.sourceView = imageFiltersScreenModule?.view
        popup.sourceRect = CGRect(x: (imageFiltersScreenModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (imageFiltersScreenModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }
    
    imageFiltersScreenModule?.present(activityViewController, animated: true, completion: nil)
    services.metricsService.track(event: .shareImageFilters)
  }
}

// MARK: - PHPickerViewControllerDelegate

extension ImageFiltersScreenCoordinator: PHPickerViewControllerDelegate {
  @available(iOS 14.0, *)
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    for item in results {
      item.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
        guard let image = image as? UIImage,
              let imageData = image.jpegData(compressionQuality: 1) else {
          DispatchQueue.main.async {
            self?.services.notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
                                                                     glyph: false,
                                                                     timeout: nil,
                                                                     active: {})
          }
          return
        }
        DispatchQueue.main.async {
          self?.imageFiltersScreenModule?.uploadContentImage(imageData)
        }
      }
    }
    picker.dismiss(animated: true)
  }
}

// MARK: - UINavigationControllerDelegate, UIImagePickerControllerDelegate

extension ImageFiltersScreenCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
          let imageData = image.jpegData(compressionQuality: 1.0) else {
      services.notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
                                                         glyph: false,
                                                         timeout: nil,
                                                         active: {})
      return
    }
    imageFiltersScreenModule?.uploadContentImage(imageData)
    picker.dismiss(animated: true)
  }
}

// MARK: - UIDocumentPickerDelegate

extension ImageFiltersScreenCoordinator: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let url = urls.first, let imageData = try? Data(contentsOf: url) else {
      services.notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
                                                         glyph: false,
                                                         timeout: nil,
                                                         active: {})
      return
    }
    imageFiltersScreenModule?.uploadContentImage(imageData)
  }
}

// MARK: - Private

private extension ImageFiltersScreenCoordinator {
  func openImageFiltersActionSheet() {
    imageFiltersScreenModule?.present(getImageFiltersActionSheet(), animated: true)
  }
  
  func getImageFiltersActionSheet() -> UIAlertController {
    let appearance = Appearance()
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    alert.addAction(.init(title: appearance.chooseFromFile, style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      self.openDocumentPickerModule()
    }))
    alert.addAction(.init(title: appearance.chooseFromGallery, style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      self.imageFiltersScreenModule?.requestGalleryActionSheetStatus()
    }))
    alert.addAction(.init(title: appearance.takePhoto, style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      self.imageFiltersScreenModule?.requestCameraActionSheetStatus()
    }))
    alert.addAction(.init(title: appearance.actionTitleCancel, style: .cancel, handler: { _ in }))
    return alert
  }
  
  func openDocumentPickerModule() {
    let types: [String] = [kUTTypeImage as String]
    let documentPicker = UIDocumentPickerViewController(documentTypes: types, in: .import)
    documentPicker.delegate = self
    documentPicker.modalPresentationStyle = .formSheet
    imageFiltersScreenModule?.present(documentPicker, animated: true, completion: nil)
  }
  
  func openGalleryModule() {
    imageFiltersScreenModule?.present(getGalleryModule(), animated: true, completion: nil)
  }
  
  func openCameraModule() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.sourceType = .camera
    imagePickerController.allowsEditing = false
    imagePickerController.delegate = self
    imageFiltersScreenModule?.present(imagePickerController, animated: true, completion: nil)
  }
  
  func getGalleryModule() -> UIViewController {
    if #available(iOS 14.0, *) {
      var imagePickerControllerConfig = PHPickerConfiguration(photoLibrary: .shared())
      imagePickerControllerConfig.selectionLimit = Appearance().selectionLimit
      imagePickerControllerConfig.filter = PHPickerFilter.any(of: [.images])
      let imagePickerController = PHPickerViewController(configuration: imagePickerControllerConfig)
      imagePickerController.delegate = self
      return imagePickerController
    } else {
      let imagePickerController = UIImagePickerController()
      imagePickerController.sourceType = .photoLibrary
      imagePickerController.allowsEditing = false
      imagePickerController.delegate = self
      return imagePickerController
    }
  }
}

// MARK: - Appearance

private extension ImageFiltersScreenCoordinator {
  struct Appearance {
    let allowAccessToGallery = RandomStrings.Localizable.allowGalleryAccess
    let failedLoadImage = RandomStrings.Localizable.failedToLoadImage
    let failedSomeError = RandomStrings.Localizable.error
    let chooseFromFile = RandomStrings.Localizable.imageFromFiles
    let chooseFromGallery = RandomStrings.Localizable.imageFromGallery
    let takePhoto = RandomStrings.Localizable.takePhoto
    let actionTitleCancel = RandomStrings.Localizable.cancel
    let selectionLimit = 1
  }
}
