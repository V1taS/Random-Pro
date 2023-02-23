//
//  PlayerCardSelectionScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import UIKit
import RandomUIKit
import ApplicationInterface

/// Cобытия которые отправляем из Factory в Presenter
protocol PlayerCardSelectionScreenFactoryOutput: AnyObject {
  
  /// Были сгенерированы модельки
  ///  - Parameter models: Модель с даными
  func didGenerated(models: [PlayerCardSelectionScreenModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol PlayerCardSelectionScreenFactoryInput {
  
  /// Создать первоначальную модельку
  /// - Parameter isPremium: Премиум доступ
  func createInitialModelWith(isPremium: Bool)
  
  /// Выбрана карточка игрока
  /// - Parameters:
  ///  - selectStyle: Выбрана карточка
  ///  - models: Текущие карточки
  ///  - isPremium: Режим премиум
  func createModelWith(selectStyle: PlayerView.StyleCard,
                       with models: [PlayerCardSelectionScreenModel],
                       isPremium: Bool)
  
  /// Обновить статус премиум в модельках
  /// - Parameters:
  ///  - models: Текущие карточки
  ///  - isPremium: Режим премиум
  func updateModels(_ models: [PlayerCardSelectionScreenModel], isPremium: Bool)
}

/// Фабрика
final class PlayerCardSelectionScreenFactory: PlayerCardSelectionScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PlayerCardSelectionScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func updateModels(_ models: [PlayerCardSelectionScreenModel], isPremium: Bool) {
    let appearance = Appearance()
    let newModels = models.map {
      return PlayerCardSelectionScreenModel(id: UUID().uuidString,
                                            name: appearance.mockPlayer,
                                            avatar: appearance.mockImagePlayer,
                                            style: $0.style,
                                            playerCardSelection: $0.playerCardSelection,
                                            isPremium: isPremium)
    }
    output?.didGenerated(models: newModels)
  }
  
  func createModelWith(selectStyle: PlayerView.StyleCard,
                       with models: [PlayerCardSelectionScreenModel],
                       isPremium: Bool) {
    let appearance = Appearance()
    var newModels: [PlayerCardSelectionScreenModel] = []
    let styleCard: PlayerCardSelectionScreenModel.StyleCard
    switch selectStyle {
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
    
    models.forEach { model in
      let modelStyle = (model.style as? PlayerCardSelectionScreenModel.StyleCard) ?? .defaultStyle
      if modelStyle == styleCard {
        newModels.append(.init(id: model.id,
                               name: appearance.mockPlayer,
                               avatar: appearance.mockImagePlayer,
                               style: model.style,
                               playerCardSelection: true,
                               isPremium: isPremium))
      } else {
        newModels.append(.init(id: model.id,
                               name: appearance.mockPlayer,
                               avatar: appearance.mockImagePlayer,
                               style: model.style,
                               playerCardSelection: false,
                               isPremium: isPremium))
      }
    }
    output?.didGenerated(models: newModels)
  }
  
  func createInitialModelWith(isPremium: Bool) {
    let appearance = Appearance()
    var models: [PlayerCardSelectionScreenModel] = []
    
    models.append(.init(id: UUID().uuidString,
                        name: appearance.mockPlayer,
                        avatar: appearance.mockImagePlayer,
                        style: PlayerCardSelectionScreenModel.StyleCard.defaultStyle,
                        playerCardSelection: true,
                        isPremium: isPremium))
    
    let otherCards = PlayerView.StyleCard.allCases.filter { $0 != .defaultStyle }
    otherCards.forEach {
      let styleCard: PlayerCardSelectionScreenModel.StyleCard
      switch $0 {
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
      
      models.append(.init(id: UUID().uuidString,
                          name: appearance.mockPlayer,
                          avatar: appearance.mockImagePlayer,
                          style: styleCard,
                          playerCardSelection: false,
                          isPremium: isPremium))
    }
    output?.didGenerated(models: models)
  }
}

// MARK: - Private

private extension PlayerCardSelectionScreenFactory {}

// MARK: - Appearance

private extension PlayerCardSelectionScreenFactory {
  struct Appearance {
    let mockPlayer = NSLocalizedString("Игрок", comment: "")
    let mockImagePlayer = "male_player4"
  }
}
