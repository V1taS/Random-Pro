//
//  CubesStyleSelectionScreenInteractor.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol CubesStyleSelectionScreenInteractorOutput: AnyObject {

  /// Были получены данные
  ///  - Parameters:
  ///   - models: Модель с даными
  ///   - isPremium: Премиум режим
  func didReceive(models: [CubesStyleSelectionScreenModel], isPremium: Bool)

  /// Была получена пустая модель
  ///  - Parameter isPremium: Премиум режим
  func didReceiveEmptyModelWith(isPremium: Bool)
}

/// События которые отправляем от Presenter к Interactor
protocol CubesStyleSelectionScreenInteractorInput {

  /// Получить данные
  func getContent()

  /// Получить премиум режим
  func getIsPremium() -> Bool

  /// Сохранить стиль кубиков
  /// - Parameters:
  ///  - cubesStyle: Стиль кубиков
  ///  - models: Модель данных
  func saveCubesStyle(_ cubesStyle: CubesStyleSelectionScreenModel.CubesStyle, with models: [CubesStyleSelectionScreenModel])
}

/// Интерактор
final class CubesStyleSelectionScreenInteractor: CubesStyleSelectionScreenInteractorInput {
  
  // MARK: - Private properties
  
  weak var output: CubesStyleSelectionScreenInteractorOutput?
  
  private var storageService: StorageService
  private var cubesSelectionScreenModel: [CubesStyleSelectionScreenModel]? {
    get {
      storageService.getData(from: [CubesStyleSelectionScreenModel].self)
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

  func getContent() {
    let isPremium = storageService.isPremium

    guard isPremium else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
      return
    }

    if let model = cubesSelectionScreenModel {
      output?.didReceive(models: model, isPremium: isPremium)
    } else {
      output?.didReceiveEmptyModelWith(isPremium: isPremium)
    }
  }

  func saveCubesStyle(_ cubesStyle: CubesStyleSelectionScreenModel.CubesStyle, with models: [CubesStyleSelectionScreenModel]) {
    guard (cubesSelectionScreenModel) != nil else {
      cubesSelectionScreenModel = models
      return
    }
    let newModel = models.map {
      return CubesStyleSelectionScreenModel(cubesStyleSelection: $0.cubesStyle == cubesStyle,
                                             isPremium: $0.isPremium,
                                            cubesStyle: $0.cubesStyle)
    }
    cubesSelectionScreenModel = newModel
  }
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenInteractor {
  struct Appearance {}
}
