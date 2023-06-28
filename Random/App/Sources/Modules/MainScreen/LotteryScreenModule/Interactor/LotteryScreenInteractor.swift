//
//  LotteryScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LotteryScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: LotteryScreenModel)
  
  /// Неправильный диапазон чисел
  func didReceiveRangeError()
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: LotteryScreenModel)
}

protocol LotteryScreenInteractorInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Получить данные
  func getContent()
  
  /// Создать новые данные для количественного textField и диапазонов textField
  /// - Parameters:
  ///  - rangeStartValue: стартовый textField диапазона
  ///  - rangeEndValue: финальный textField диапазона
  ///  - amountNumberValue: количественный textField
  func generateContent(rangeStartValue: String?,
                       rangeEndValue: String?,
                       amountNumberValue: String?)
}

final class LotteryScreenInteractor: LotteryScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: LotteryScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private let buttonCounterService: ButtonCounterService
  private var lotteryScreenModel: LotteryScreenModel? {
    get {
      storageService.getData(from: LotteryScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    lotteryScreenModel = nil
    getContent()
    guard let model = lotteryScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContent(rangeStartValue: String?, rangeEndValue: String?, amountNumberValue: String?) {
    buttonCounterService.onButtonClick()
    
    let rangeStartValue = rangeStartValue ?? ""
    let rangeStartValueNumber = Int(rangeStartValue) ?? .zero
    
    let rangeEndValue = rangeEndValue ?? ""
    let rangeEndValueNumber = Int(rangeEndValue) ?? .zero
    
    let amountNumberValue = amountNumberValue ?? ""
    let amountNumberValueInt = Int(amountNumberValue) ?? .zero
    
    guard rangeStartValueNumber < rangeEndValueNumber else {
      output?.didReceiveRangeError()
      return
    }
    
    guard let model = lotteryScreenModel else {
      return
    }
    
    let rangeNumber = rangeStartValueNumber...rangeEndValueNumber
    let rangeNumberRandom = rangeNumber.shuffled()
    let rangeNumberRandomString = rangeNumberRandom.map { "\($0)"}
    
    // swiftlint:disable all
    let arrayResult = Array<String>(rangeNumberRandomString.prefix(amountNumberValueInt))
    // swiftlint:enable all
    let numbersResult = arrayResult.joined(separator: ", ")
    var listResult = model.listResult
    listResult.append(numbersResult)
    
    let newModel = LotteryScreenModel(
      rangeStartValue: rangeStartValue,
      rangeEndValue: rangeEndValue,
      amountValue: amountNumberValue,
      result: numbersResult,
      listResult: listResult
    )
    self.lotteryScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func returnListResult() -> [String] {
    if let model = lotteryScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
}

// MARK: - Private

private extension LotteryScreenInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = lotteryScreenModel {
      output?.didReceive(model: model)
    } else {
      let appearance = Appearance()
      let model = LotteryScreenModel(
        rangeStartValue: appearance.startTextFieldValue,
        rangeEndValue: appearance.endTextFieldValue,
        amountValue: appearance.amountTextFieldValue,
        result: appearance.result,
        listResult: []
      )
      self.lotteryScreenModel = model
      output?.didReceive(model: model)
    }
  }
}

// MARK: - Appearance

private extension LotteryScreenInteractor {
  struct Appearance {
    let result = "?"
    let startTextFieldValue = "1"
    let amountTextFieldValue = "6"
    let endTextFieldValue = "49"
  }
}
