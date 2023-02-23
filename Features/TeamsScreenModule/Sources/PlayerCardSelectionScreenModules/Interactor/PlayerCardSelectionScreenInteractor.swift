//
//  PlayerCardSelectionScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import UIKit
import RandomUIKit
import ApplicationInterface

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
  func savePlayerCardStyle(_ style: PlayerView.StyleCard,
                           with models: [PlayerCardSelectionScreenModelProtocol])
}

/// Интерактор
final class PlayerCardSelectionScreenInteractor: PlayerCardSelectionScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PlayerCardSelectionScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageServiceProtocol
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - storageService: Сервис сохранения даных
  init(storageService: StorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func getIsPremium() -> Bool {
    return storageService.isPremium
  }
  
  func savePlayerCardStyle(_ style: PlayerView.StyleCard,
                           with models: [PlayerCardSelectionScreenModelProtocol]) {
    guard (storageService.playerCardSelectionScreenModel) != nil else {
      storageService.playerCardSelectionScreenModel = models
      return
    }
    
    let styleCard: PlayerCardSelectionScreenModel.StyleCard
    switch style {
    case .defaultStyle:
      styleCard = .defaultStyle
    case .darkGreen:
      styleCard = .darkGreen
    case .darkBlue:
      styleCard = .darkBlue
    case .darkOrange:
      styleCard = .darkOrange
    case .darkRed:
      styleCard = .darkRed
    case .darkPurple:
      styleCard = .darkPurple
    case .darkPink:
      styleCard = .darkPink
    case .darkYellow:
      styleCard = .darkYellow
    }
    
    let newModel = models.map {
      return PlayerCardSelectionScreenModel(
        id: $0.id,
        name: $0.name,
        avatar: $0.avatar,
        style: $0.style,
        playerCardSelection: ($0.style as? PlayerCardSelectionScreenModel.StyleCard) ?? .defaultStyle == styleCard,
        isPremium: $0.isPremium
      )
    }
    storageService.playerCardSelectionScreenModel = newModel
  }
  
  func getContent() {
    let isPremium = storageService.isPremium
    
    guard isPremium else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
      return
    }
    
    if let model = storageService.playerCardSelectionScreenModel?.toCodable() {
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
