//
//  ImageFiltersScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ImageFiltersScreenInteractorOutput: AnyObject {
  
  /// Получен доступ к галерее для сохранения фото
  func requestShareGallerySuccess()
  
  /// Получен доступ к галерее
  func requestGalleryActionSheetSuccess()
  
  /// Получен доступ к камере
  func requestCameraActionSheetSuccess()
  
  /// Доступ к галерее не получен
  func requestGalleryError()
}

/// События которые отправляем от Presenter к Interactor
protocol ImageFiltersScreenInteractorInput {
  
  /// Запрос доступа к Галерее для сохранения фото
  func requestShareGalleryStatus()
  
  /// Запрос доступа к Галерее через шторку
  func requestGalleryActionSheetStatus()
  
  /// Запрос доступа к Камере через шторку
  func requestCameraActionSheetStatus()
  
  /// Сгенерировать новый фильтр
  /// - Parameter image: Изображение
  func generateImageFilterFor(image: Data?)
}

/// Интерактор
final class ImageFiltersScreenInteractor: ImageFiltersScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ImageFiltersScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameter services: Сервисы приложения
  init(services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func generateImageFilterFor(image: Data?) {
    services.buttonCounterService.onButtonClick()
  }
  
  func requestShareGalleryStatus() {
    permissionGallery { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestShareGallerySuccess()
      case false:
        self?.output?.requestGalleryError()
      }
    }
  }
  
  func requestGalleryActionSheetStatus() {
    permissionGallery { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestGalleryActionSheetSuccess()
      case false:
        self?.output?.requestGalleryError()
      }
    }
  }
  
  func requestCameraActionSheetStatus() {
    services.permissionService.requestCamera { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestCameraActionSheetSuccess()
      case false:
        self?.output?.requestGalleryError()
      }
    }
  }
}

// MARK: - Private

private extension ImageFiltersScreenInteractor {
  func permissionGallery(completion: @escaping (Bool) -> Void) {
    services.permissionService.requestPhotos { granted in
      completion(granted)
    }
  }
}

// MARK: - Appearance

private extension ImageFiltersScreenInteractor {
  struct Appearance {}
}
