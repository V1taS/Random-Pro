//
//  CoinStyleSelectionScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol CoinStyleSelectionScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameters:
  ///   - models: Модель с даными
  ///   - isPremium: Премиум режим
  func didReceive(models: [CoinStyleSelectionScreenModel], isPremium: Bool)

  /// Была получена пустая модель
  ///  - Parameter isPremium: Премиум режим
  func didReceiveEmptyModelWith(isPremium: Bool)

}

/// События которые отправляем от Presenter к Interactor
protocol CoinStyleSelectionScreenInteractorInput {

  /// Получить данные
  func getContent()

  /// Получить премиум режим
  func getIsPremium() -> Bool

  /// Сохранить стиль монетки
  /// - Parameters:
  ///  - coinStyle: Стиль монетки
  ///  - models: Модель данных
  func saveCoinStyle(_ coinStyle: CoinStyleSelectionScreenModel.CoinStyle, with models: [CoinStyleSelectionScreenModel])

}

/// Интерактор
final class CoinStyleSelectionScreenInteractor: CoinStyleSelectionScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: CoinStyleSelectionScreenInteractorOutput?

  // MARK: - Private property

  private var storageService: StorageService
  private var coinSelectionScreenModel: [CoinStyleSelectionScreenModel]? {
    get {
      storageService.getData(from: [CoinStyleSelectionScreenModel].self)
    } set {
      storageService.saveData(newValue)
    }
  }

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

  func saveCoinStyle(_ coinStyle: CoinStyleSelectionScreenModel.CoinStyle, with models: [CoinStyleSelectionScreenModel]) {
    guard (coinSelectionScreenModel) != nil else {
      coinSelectionScreenModel = models
      return
    }

    let newModel = models.map {
      return CoinStyleSelectionScreenModel(coinStyleSelection: $0.coinStyle == coinStyle,
                                           isPremium: $0.isPremium,
                                           coinStyle: $0.coinStyle)
    }
    coinSelectionScreenModel = newModel
  }

  func getContent() {
    let isPremium = storageService.isPremium

    guard isPremium else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
      return
    }

    if let model = coinSelectionScreenModel {
      output?.didReceive(models: model, isPremium: isPremium)
    } else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
    }
  }
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenInteractor {
  struct Appearance {}
}
