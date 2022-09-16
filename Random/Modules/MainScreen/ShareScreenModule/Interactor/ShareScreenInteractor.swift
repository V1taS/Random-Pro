//
//  ShareScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ShareScreenInteractorOutput: AnyObject {
  
  /// Доступ получен к Галерее
  func requestPhotosSuccess()
  
  /// Доступ  не получен к Галерее
  func requestPhotosError()
}

/// События которые отправляем от Presenter к Interactor
protocol ShareScreenInteractorInput {
  
  /// Запрос доступа к Галерее
  func requestPhotosStatus()
}

/// Интерактор
final class ShareScreenInteractor: ShareScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ShareScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let permissionService: PermissionService
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameter permissionService: Сервис по работе с разрешениями
  init(permissionService: PermissionService) {
    self.permissionService = permissionService
  }
  
  // MARK: - Internal func
  
  func requestPhotosStatus() {
    permissionService.requestPhotos { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestPhotosSuccess()
      case false:
        self?.output?.requestPhotosError()
      }
    }
  }
}

// MARK: - Appearance

private extension ShareScreenInteractor {
  struct Appearance {}
}
