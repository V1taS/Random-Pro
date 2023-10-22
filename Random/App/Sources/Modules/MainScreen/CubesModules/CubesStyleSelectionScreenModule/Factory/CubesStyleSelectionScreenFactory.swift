//
//  CubesStyleSelectionScreenFactory.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol CubesStyleSelectionScreenFactoryOutput: AnyObject {
  /// Были сгенерированы модельки
  ///  - Parameter models: Модель с даными
  func didGenerated(models: [CubesStyleSelectionScreenModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol CubesStyleSelectionScreenFactoryInput {

  /// Создать первоначальную модельку
  /// - Parameter isPremium: Премиум доступ
  func createInitialModelWith(isPremium: Bool)

  /// Выбрана карточка игрока
  /// - Parameters:
  ///  - selectStyle: Выбрана карточка
  ///  - models: Текущие бутылочки
  ///  - isPremium: Режим премиум
  func createModelWith(selectStyle: CubesStyleSelectionScreenModel.CubesStyle,
                       with models: [CubesStyleSelectionScreenModel],
                       isPremium: Bool)

  /// Обновить статус премиум в модельках
  /// - Parameters:
  ///  - models: Текущие бутылочки
  ///  - isPremium: Режим премиум
  func updateModels(_ models: [CubesStyleSelectionScreenModel], isPremium: Bool)
}

/// Фабрика
final class CubesStyleSelectionScreenFactory: CubesStyleSelectionScreenFactoryInput {

  // MARK: - Internal properties
  
  weak var output: CubesStyleSelectionScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createInitialModelWith(isPremium: Bool) {
    var models: [CubesStyleSelectionScreenModel] = []
    
    models.append(.init(cubesStyleSelection: true,
                        isPremium: isPremium,
                        cubesStyle: .defaultStyle))
    
    let otherCards = CubesStyleSelectionScreenModel.CubesStyle.allCases.filter { $0 != .defaultStyle }
    otherCards.forEach {
      models.append(.init(cubesStyleSelection: false,
                          isPremium: isPremium,
                          cubesStyle: $0))
    }
    output?.didGenerated(models: models)
  }
  
  func createModelWith(selectStyle: CubesStyleSelectionScreenModel.CubesStyle,
                       with models: [CubesStyleSelectionScreenModel],
                       isPremium: Bool) {
    var newModels: [CubesStyleSelectionScreenModel] = []
    
    models.forEach { model in
      if model.cubesStyle == selectStyle {
        newModels.append(.init(cubesStyleSelection: true,
                               isPremium: isPremium,
                               cubesStyle: model.cubesStyle))
      } else {
        newModels.append(.init(cubesStyleSelection: false,
                               isPremium: isPremium,
                               cubesStyle: model.cubesStyle))
      }
    }
    output?.didGenerated(models: newModels)
  }
  
  func updateModels(_ models: [CubesStyleSelectionScreenModel], isPremium: Bool) {
    let newModels = models.map {
      return CubesStyleSelectionScreenModel(
        cubesStyleSelection: $0.cubesStyleSelection,
        isPremium: isPremium,
        cubesStyle: $0.cubesStyle
      )
    }
    output?.didGenerated(models: newModels)
  }
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenFactory {
  struct Appearance {}
}
