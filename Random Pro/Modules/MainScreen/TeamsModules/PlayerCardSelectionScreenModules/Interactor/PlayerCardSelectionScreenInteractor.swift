//
//  PlayerCardSelectionScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из Interactor в Presenter
protocol PlayerCardSelectionScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - models: Модель с даными
  ///   - isPremium: Премиум режим
  func didReceive(models: [PlayerCardSelectionScreenModel], isPremium: Bool)
  
  /// Была получена пустая модель
  ///  - Parameter isPremium: Премиум режим
  func didReceiveEmptyModelWith(isPremium: Bool)
}

/// События которые отправляем от Presenter к Interactor
protocol PlayerCardSelectionScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Получить премиум режим
  func getIsPremium() -> Bool
  
  /// Сохранить стиль карточки
  /// - Parameters:
  ///  - style: Стиль карточки
  ///  - models: Модель данных
  func savePlayerCardStyle(_ style: PlayerView.StyleCard, with models: [PlayerCardSelectionScreenModel])
}

/// Интерактор
final class PlayerCardSelectionScreenInteractor: PlayerCardSelectionScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PlayerCardSelectionScreenInteractorOutput?
  
  // MARK: - Private property

  private var storageService: StorageService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func getIsPremium() -> Bool {
    return storageService.isPremium
  }
  
  func savePlayerCardStyle(_ style: PlayerView.StyleCard, with models: [PlayerCardSelectionScreenModel]) {
    guard (storageService.playerCardSelectionScreenModel) != nil else {
      storageService.playerCardSelectionScreenModel = models
      return
    }
    
    let newModel = models.map {
      return PlayerCardSelectionScreenModel(id: $0.id,
                                            name: $0.name,
                                            avatar: $0.avatar,
                                            style: $0.style,
                                            playerCardSelection: $0.style == style,
                                            isPremium: $0.isPremium)
    }
    storageService.playerCardSelectionScreenModel = newModel
  }
  
  func getContent() {
    let isPremium = storageService.isPremium
    
    guard isPremium else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
      return
    }
    
    if let model = storageService.playerCardSelectionScreenModel {
      output?.didReceive(models: model, isPremium: isPremium)
    } else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
    }
  }
}

// MARK: - Appearance

private extension PlayerCardSelectionScreenInteractor {
  struct Appearance {}
}
