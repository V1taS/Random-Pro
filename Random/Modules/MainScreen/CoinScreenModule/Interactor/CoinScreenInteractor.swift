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

protocol CoinScreenInteractorInput: AnyObject {
  
  /// Получить данные
  func getContent()
  
  /// Создать новые данные генерации
  func generateContentCoin()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
}

final class CoinScreenInteractor: CoinScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenInteractorOutput?
  
  // MARK: - Private property
  
  @ObjectCustomUserDefaultsWrapper<CoinScreenModel>(key: Appearance().keyUserDefaults)
  private var model: CoinScreenModel?
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    model = nil
    getContent()
    guard let model = model else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContentCoin() {
    let appearance = Appearance()
    guard let model = model else {
      return
    }
    
    let randonIndex = Int.random(in: 0...1)
    let randomName = appearance.namesCoin[randonIndex]
    let сoinType: CoinScreenModel.CoinType = randonIndex == .zero ? .eagle : .tails
    
    var listResult = model.listResult
    listResult.append(randomName)
    
    let newModel = CoinScreenModel(
      result: randomName,
      сoinType: сoinType,
      listResult: listResult
    )
    
    self.model = newModel
    output?.didReceive(model: newModel)
  }
  
  func returnListResult() -> [String] {
    if let model = model {
      return model.listResult
    } else {
      return []
    }
  }
}

// MARK: - Private

private extension CoinScreenInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = model {
      output?.didReceive(model: model)
    } else {
      let model = CoinScreenModel(
        result: Appearance().resultName,
        сoinType: .none,
        listResult: []
      )
      self.model = model
      output?.didReceive(model: model)
    }
  }
}

// MARK: - CoinScreenInteractor

private extension CoinScreenInteractor {
  struct Appearance {
    let resultName = "?"
    let namesCoin = [
      NSLocalizedString("Орел", comment: ""),
      NSLocalizedString("Решка", comment: "")
    ]
    let keyUserDefaults = "coin_screen_user_defaults_key"
  }
}
