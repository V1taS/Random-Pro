//
//  ColorsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ColorsScreenInteractorOutput: AnyObject {
  
  /// Доступ к галерее получен
  func requestGallerySuccess()
  
  /// Доступ к галерее не получен
  func requestGalleryError()
}

/// События которые отправляем от Presenter к Interactor
protocol ColorsScreenInteractorInput {
  
  /// Запрос доступа к Галерее
  func requestGalleryStatus()
  
  /// Была нажата кнопка сгенерировать результат
  ///  - Parameter text: Результат генерации
  func generateResultButtonPressed(text: String?)
}

/// Интерактор
final class ColorsScreenInteractor: ColorsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ColorsScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameter services: Сервисы приложения
  init(services: ApplicationServices) {
    self.services = services
  }
  
  func generateResultButtonPressed(text: String?) {
    services.buttonCounterService.onButtonClick()
  }
  
  // MARK: - Internal func
  
  func requestGalleryStatus() {
    services.permissionService.requestPhotos { [weak self] granted in
      switch granted {
      case true:
        self?.output?.requestGallerySuccess()
      case false:
        self?.output?.requestGalleryError()
      }
    }
  }
}

// MARK: - Appearance

private extension ColorsScreenInteractor {
  struct Appearance {}
}
