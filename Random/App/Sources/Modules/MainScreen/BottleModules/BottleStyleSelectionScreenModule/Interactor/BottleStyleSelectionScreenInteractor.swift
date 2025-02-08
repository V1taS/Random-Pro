//
//  BottleStyleSelectionScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol BottleStyleSelectionScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameters:
  ///   - models: Модель с даными
  ///   - isPremium: Премиум режим
  func didReceive(models: [BottleStyleSelectionScreenModel], isPremium: Bool)

  /// Была получена пустая модель
  ///  - Parameter isPremium: Премиум режим
  func didReceiveEmptyModelWith(isPremium: Bool)
}

/// События которые отправляем от Presenter к Interactor
protocol BottleStyleSelectionScreenInteractorInput {

  /// Получить данные
  func getContent()

  /// Получить премиум режим
  func getIsPremium() -> Bool

  /// Сохранить стиль бутылочки
  /// - Parameters:
  ///  - bottleStyle: Стиль бутылочки
  ///  - models: Модель данных
  func saveBottleStyle(_ bottleStyle: BottleStyleSelectionScreenModel.BottleStyle, with models: [BottleStyleSelectionScreenModel])
}

/// Интерактор
final class BottleStyleSelectionScreenInteractor: BottleStyleSelectionScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: BottleStyleSelectionScreenInteractorOutput?

  // MARK: - Private property

  private var storageService: StorageService
  private var bottleSelectionScreenModel: [BottleStyleSelectionScreenModel]? {
    get {
      storageService.getData(from: [BottleStyleSelectionScreenModel].self)
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

  func saveBottleStyle(_ bottleStyle: BottleStyleSelectionScreenModel.BottleStyle, with models: [BottleStyleSelectionScreenModel]) {
    guard (bottleSelectionScreenModel) != nil else {
      bottleSelectionScreenModel = models
      return
    }

    let newModel = models.map {
      return BottleStyleSelectionScreenModel(bottleStyleSelection: $0.bottleStyle == bottleStyle,
                                             isPremium: $0.isPremium,
                                             bottleStyle: $0.bottleStyle)
    }
    bottleSelectionScreenModel = newModel
  }

  func getContent() {
    let isPremium = storageService.isPremium

    guard isPremium else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
      return
    }

    if let model = bottleSelectionScreenModel {
      output?.didReceive(models: model, isPremium: isPremium)
    } else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
    }
  }
}

// MARK: - Appearance

private extension BottleStyleSelectionScreenInteractor {
  struct Appearance {}
}
