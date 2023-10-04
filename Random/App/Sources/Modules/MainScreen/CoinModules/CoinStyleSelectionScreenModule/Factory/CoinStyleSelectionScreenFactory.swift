//
//  CoinStyleSelectionScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol CoinStyleSelectionScreenFactoryOutput: AnyObject {

  /// Были сгенерированы модельки
  ///  - Parameter models: Модель с даными
  func didGenerated(models: [CoinStyleSelectionScreenModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol CoinStyleSelectionScreenFactoryInput {

  /// Создать первоначальную модельку
  /// - Parameter isPremium: Премиум доступ
  func createInitialModelWith(isPremium: Bool)

  /// Выбран стиль монетки
  /// - Parameters:
  ///  - selectStyle: Выбрана монетка
  ///  - models: Текущие монетки
  ///  - isPremium: Режим премиум
  func createModelWith(selectStyle: CoinStyleSelectionScreenModel.CoinStyle,
                       with models: [CoinStyleSelectionScreenModel],
                       isPremium: Bool)

  /// Обновить статус премиум в модельках
  /// - Parameters:
  ///  - models: Текущие монетки
  ///  - isPremium: Режим премиум
  func updateModels(_ models: [CoinStyleSelectionScreenModel], isPremium: Bool)
}

/// Фабрика
final class CoinStyleSelectionScreenFactory: CoinStyleSelectionScreenFactoryInput {

  // MARK: - Internal properties
  
  weak var output: CoinStyleSelectionScreenFactoryOutput?
  
  // MARK: - Internal func

  func createInitialModelWith(isPremium: Bool) {
    var models: [CoinStyleSelectionScreenModel] = []

    models.append(.init(coinStyleSelection: true,
                        isPremium: isPremium,
                        coinStyle: .defaultStyle))

    let otherCoins = CoinStyleSelectionScreenModel.CoinStyle.allCases.filter { $0 != .defaultStyle}
    otherCoins.forEach {
      models.append(.init(coinStyleSelection: false,
                          isPremium: isPremium,
                          coinStyle: $0))
    }
    output?.didGenerated(models: models)
  }

  func createModelWith(selectStyle: CoinStyleSelectionScreenModel.CoinStyle,
                       with models: [CoinStyleSelectionScreenModel],
                       isPremium: Bool) {
    var newModels: [CoinStyleSelectionScreenModel] = []

    models.forEach { model in
      if model.coinStyle == selectStyle {
        newModels.append(.init(coinStyleSelection: true,
                               isPremium: isPremium,
                               coinStyle: model.coinStyle))
      } else {
        newModels.append(.init(coinStyleSelection: false,
                               isPremium: isPremium,
                               coinStyle: model.coinStyle))
      }
    }
    output?.didGenerated(models: newModels)
  }

  func updateModels(_ models: [CoinStyleSelectionScreenModel], isPremium: Bool) {
    let newModels = models.map {
      return CoinStyleSelectionScreenModel(
        coinStyleSelection: $0.coinStyleSelection,
        isPremium: isPremium,
        coinStyle: $0.coinStyle
      )
    }
    output?.didGenerated(models: newModels)
  }
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenFactory {
  struct Appearance {}
}
