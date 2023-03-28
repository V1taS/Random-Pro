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
import ImageFiltersScreenModule
import NotificationService
import FileManagerService
import PermissionService
import YandexMobileMetrica
import FirebaseAnalytics
import MetricsService

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
  private var imageFiltersScreenModule: ImageFiltersScreenModule?
  private let notificationService = NotificationServiceImpl()
  private let fileManagerService = FileManagerImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let imageFiltersScreenModule = ImageFiltersScreenAssembly().createModule(permissionService: PermissionServiceImpl())
    self.imageFiltersScreenModule = imageFiltersScreenModule
    self.imageFiltersScreenModule?.moduleOutput = self
    navigationController.pushViewController(imageFiltersScreenModule, animated: true)
  }
}

// MARK: - ColorsScreenModuleOutput

extension ImageFiltersScreenCoordinator: ImageFiltersScreenModuleOutput {
  func didReceiveError() {
    notificationService.showNegativeAlertWith(
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
    notificationService.showNegativeAlertWith(
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
      let imageFile = fileManagerService.saveObjectWith(fileName: "Random",
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
    track(event: .shareImageFilters)
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
            self?.notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
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
      notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
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
      notificationService.showNegativeAlertWith(title: Appearance().failedLoadImage,
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
  
  func track(event: MetricsSections) {
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsSections, properties: [String: String]) {
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}

// MARK: - Adapter PermissionService

extension PermissionServiceImpl: ImageFiltersPermissionServiceProtocol {}

// MARK: - Appearance

private extension ImageFiltersScreenCoordinator {
  struct Appearance {
    let allowAccessToGallery = NSLocalizedString("Разрешить доступ к галерее", comment: "")
    let failedLoadImage = NSLocalizedString("Не удалось загрузить изображение", comment: "")
    let failedSomeError = NSLocalizedString("Ошибка", comment: "")
    let chooseFromFile = NSLocalizedString("Изображение из файлов", comment: "")
    let chooseFromGallery = NSLocalizedString("Изображение из галереи", comment: "")
    let takePhoto = NSLocalizedString("Сделать фото", comment: "")
    let actionTitleCancel = NSLocalizedString("Отмена", comment: "")
    let selectionLimit = 1
  }
}
