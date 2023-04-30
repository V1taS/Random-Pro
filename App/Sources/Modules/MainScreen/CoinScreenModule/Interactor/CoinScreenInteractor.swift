//
//  CoinScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CoinScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: CoinScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: CoinScreenModel)
}

protocol CoinScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Создать новые данные генерации
  func generateContentCoin()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Запустить обратную связь от моторчика
  func playHapticFeedback()
}

final class CoinScreenInteractor: CoinScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenInteractorOutput?
  
  // MARK: - Private property
  
  private let hapticService: HapticService
  private var storageService: StorageService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - hapticService: Обратная связь от моторчика
  ///  - services: Сервисы приложения
  init(hapticService: HapticService,
       services: ApplicationServices) {
    self.hapticService = hapticService
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    storageService.coinScreenModel = nil
    getContent()
    guard let model = storageService.coinScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContentCoin() {
    let appearance = Appearance()
    guard let model = storageService.coinScreenModel else {
      return
    }
    
    let randonIndex = Int.random(in: 0...1)
    let randomName = appearance.namesCoin[randonIndex]
    let coinType: CoinScreenModel.CoinType = randonIndex == .zero ? .eagle : .tails
    
    var listResult = model.listResult
    listResult.append(randomName)
    
    let newModel = CoinScreenModel(
      result: randomName,
      coinType: coinType,
      listResult: listResult
    )
    
    self.storageService.coinScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func returnListResult() -> [String] {
    if let model = storageService.coinScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
  
  func playHapticFeedback() {
    hapticService.play(isRepeat: false,
                       patternType: .splash,
                       completion: { _ in })
  }
}

// MARK: - Private

private extension CoinScreenInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = storageService.coinScreenModel {
      output?.didReceive(model: model)
    } else {
      let model = CoinScreenModel(
        result: Appearance().resultName,
        coinType: .none,
        listResult: []
      )
      self.storageService.coinScreenModel = model
      output?.didReceive(model: model)
    }
  }
}

// MARK: - Appearance

private extension CoinScreenInteractor {
  struct Appearance {
    let resultName = "?"
    let namesCoin = [
      NSLocalizedString("Орел", comment: ""),
      NSLocalizedString("Решка", comment: "")
    ]
  }
}
