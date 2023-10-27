//
//  CoinScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

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

  /// Обновить стиль
  func updateStyle()
}

final class CoinScreenInteractor: CoinScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenInteractorOutput?
  
  // MARK: - Private property
  
  private let hapticService: HapticService
  private var storageService: StorageService
  private var buttonCounterService: ButtonCounterService
  private var coinScreenModel: CoinScreenModel? {
    get {
      storageService.getData(from: CoinScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  private var coinStyle: CoinStyleSelectionScreenModel.CoinStyle? {
    let models = storageService.getData(from: [CoinStyleSelectionScreenModel].self)
    return models?.filter { $0.coinStyleSelection }.first?.coinStyle ?? .defaultStyle
  }
  
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

  func updateStyle() {
    guard let model = coinScreenModel else {
      return
    }

    let newModel = CoinScreenModel(result: model.result,
                                   isShowlistGenerated: model.isShowlistGenerated,
                                   coinStyle: coinStyle ?? .defaultStyle,
                                   coinSideType: model.coinSideType,
                                   listResult: model.listResult)

    self.coinScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func saveData(model: CoinScreenModel) {
    coinScreenModel = model
  }
  
  func cleanButtonAction() {
    coinScreenModel = nil
    getContent()
    guard let model = coinScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func returnModel() -> CoinScreenModel? {
    coinScreenModel
  }
  
  func generateButtonAction() {
    buttonCounterService.onButtonClick()
  }
  
  func playHapticFeedback() {
    // TODO: - пока что решил отключить
//    DispatchQueue.main.async { [weak self] in
//      self?.hapticService.play(isRepeat: false,
//                               patternType: .soft,
//                               completion: {_ in })
//    }
  }
}

// MARK: - Private

private extension CoinScreenInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = coinScreenModel {
      output?.didReceive(model: model)
    } else {
      let model = CoinScreenModel(
        result: Appearance().resultName,
        isShowlistGenerated: true,
        coinStyle: coinStyle ?? .defaultStyle,
        coinSideType: .none,
        listResult: []
      )
      self.coinScreenModel = model
      output?.didReceive(model: model)
    }
  }
}

// MARK: - Appearance

private extension CoinScreenInteractor {
  struct Appearance {
    let resultName = "?"
  }
}
