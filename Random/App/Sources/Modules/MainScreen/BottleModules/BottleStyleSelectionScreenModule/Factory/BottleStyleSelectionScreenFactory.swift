//
//  BottleStyleSelectionScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// Cобытия которые отправляем из Factory в Presenter
protocol BottleStyleSelectionScreenFactoryOutput: AnyObject {
  
  /// Были сгенерированы модельки
  ///  - Parameter models: Модель с даными
  func didGenerated(models: [BottleStyleSelectionScreenModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol BottleStyleSelectionScreenFactoryInput {
  
  /// Создать первоначальную модельку
  /// - Parameter isPremium: Премиум доступ
  func createInitialModelWith(isPremium: Bool)
  
  /// Выбрана карточка игрока
  /// - Parameters:
  ///  - selectStyle: Выбрана карточка
  ///  - models: Текущие карточки
  ///  - isPremium: Режим премиум
  func createModelWith(selectStyle: BottleStyleSelectionScreenModel.BottleStyle,
                       with models: [BottleStyleSelectionScreenModel],
                       isPremium: Bool)
  
  /// Обновить статус премиум в модельках
  /// - Parameters:
  ///  - models: Текущие карточки
  ///  - isPremium: Режим премиум
  func updateModels(_ models: [BottleStyleSelectionScreenModel], isPremium: Bool)
}

/// Фабрика
final class BottleStyleSelectionScreenFactory: BottleStyleSelectionScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: BottleStyleSelectionScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func updateModels(_ models: [BottleStyleSelectionScreenModel], isPremium: Bool) {
    let newModels = models.map {
      return BottleStyleSelectionScreenModel(
        bottleStyleSelection: $0.bottleStyleSelection,
        isPremium: isPremium,
        bottleStyle: .defaultStyle
      )
    }
    output?.didGenerated(models: newModels)
  }
  
  func createModelWith(selectStyle: BottleStyleSelectionScreenModel.BottleStyle,
                       with models: [BottleStyleSelectionScreenModel],
                       isPremium: Bool) {
    var newModels: [BottleStyleSelectionScreenModel] = []
    
    models.forEach { model in
      if model.bottleStyle == selectStyle {
        newModels.append(.init(bottleStyleSelection: true,
                               isPremium: isPremium,
                               bottleStyle: model.bottleStyle))
      } else {
        newModels.append(.init(bottleStyleSelection: false,
                               isPremium: isPremium,
                               bottleStyle: model.bottleStyle))
      }
    }
    output?.didGenerated(models: newModels)
  }
  
  func createInitialModelWith(isPremium: Bool) {
    var models: [BottleStyleSelectionScreenModel] = []
    
    models.append(.init(bottleStyleSelection: true,
                        isPremium: isPremium,
                        bottleStyle: .defaultStyle))
    
    let otherCards = BottleStyleSelectionScreenModel.BottleStyle.allCases.filter { $0 != .defaultStyle }
    otherCards.forEach {
      models.append(.init(bottleStyleSelection: false,
                          isPremium: isPremium,
                          bottleStyle: $0))
    }
    output?.didGenerated(models: models)
  }
}
