//
//  ImageFiltersScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ImageFiltersScreenInteractorOutput: AnyObject {
  
  /// Доступ получен к Галерее для сохранения фото
  func requestShareGallerySuccess()
  
  /// Доступ получен к Галерее
  func requestGalleryActionSheetSuccess()
  
  /// Доступ получен к Камере
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
}

/// Интерактор
final class ImageFiltersScreenInteractor: ImageFiltersScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ImageFiltersScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let permissionService: PermissionService
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameter permissionService: Сервис по работе с разрешениями
  init(permissionService: PermissionService) {
    self.permissionService = permissionService
  }
  
  // MARK: - Internal func
  
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
    permissionService.requestCamera { [weak self] granted in
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
    permissionService.requestPhotos { granted in
      completion(granted)
    }
  }
}

// MARK: - Appearance

private extension ImageFiltersScreenInteractor {
  struct Appearance {}
}
