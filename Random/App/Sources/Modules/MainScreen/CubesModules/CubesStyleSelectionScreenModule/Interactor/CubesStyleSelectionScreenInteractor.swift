//
//  CubesStyleSelectionScreenInteractor.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol CubesStyleSelectionScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol CubesStyleSelectionScreenInteractorInput {}

/// Интерактор
final class CubesStyleSelectionScreenInteractor: CubesStyleSelectionScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: CubesStyleSelectionScreenInteractorOutput?
  
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
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenInteractor {
  struct Appearance {}
}
