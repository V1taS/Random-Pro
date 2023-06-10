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
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Возвращает Модель данных
  func returnModel() -> CoinScreenModel?
  
  /// Запустить обратную связь от моторчика
  func playHapticFeedback()
  
  /// Сохранить данные
  ///  - Parameter model: результат генерации
  func saveData(model: CoinScreenModel)
  
  /// Была нажата кнопку генерации
  func generateButtonAction()
}

final class CoinScreenInteractor: CoinScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenInteractorOutput?
  
  // MARK: - Private property
  
  private let hapticService: HapticService
  private var storageService: StorageService
  private var buttonCounterService: ButtonCounterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - hapticService: Обратная связь от моторчика
  ///  - services: Сервисы приложения
  init(hapticService: HapticService,
       services: ApplicationServices) {
    self.hapticService = hapticService
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func saveData(model: CoinScreenModel) {
    storageService.coinScreenModel = model
  }
  
  func cleanButtonAction() {
    storageService.coinScreenModel = nil
    getContent()
    guard let model = storageService.coinScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func returnModel() -> CoinScreenModel? {
    storageService.coinScreenModel
  }
  
  func generateButtonAction() {
    buttonCounterService.onButtonClick()
  }
  
  func playHapticFeedback() {
    DispatchQueue.main.async { [weak self] in
      self?.hapticService.play(isRepeat: false,
                               patternType: .splash,
                               completion: {_ in })
    }
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
        isShowlistGenerated: true,
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
      RandomStrings.Localizable.eagle,
      RandomStrings.Localizable.tails
    ]
  }
}
