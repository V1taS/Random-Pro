//
//  NumberScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol NumberScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: NumberScreenModel)
  
  /// Были получены данные
  ///  - Parameter text: Было получено начало диапазона
  func didReceiveRangeStart(text: String?)
  
  /// Были получены данные
  ///  - Parameter text: Было получено конец диапазона
  func didReceiveRangeEnd(text: String?)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: NumberScreenModel)
  
  /// Диапазон чисел закончился
  func didReceiveRangeEnded()
  
  /// Неправильный диапазон чисел
  func didReceiveRangeError()
}

/// События которые отправляем от Presenter к Interactor
protocol NumberScreenInteractorInput {
  
  /// Возвращает основную модель данных
  func returnModel() -> NumberScreenModel
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Получить данные
  ///  - Parameter withWithoutRepetition: Включить режим "без повторений"
  func getContent(withWithoutRepetition isOn: Bool)
  
  /// Создать новые данные
  /// - Parameters:
  ///  - firstTextFieldValue: Первый textField
  ///  - secondTextFieldValue: Второй textField
  func generateContent(firstTextFieldValue: String?,
                       secondTextFieldValue: String?)
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func rangeStartDidChange(_ text: String?)
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func rangeEndDidChange(_ text: String?)
}

final class NumberScreenInteractor: NumberScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: NumberScreenInteractorOutput?
  
  // MARK: - Private property
  
  private lazy var numberFormatter = NumberFormatter()
  private var storageService: StorageService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    storageService.numberScreenModel = nil
    getContent()
    guard let model = storageService.numberScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    guard let model = storageService.numberScreenModel else {
      configureModel(withWithoutRepetition: isOn)
      return
    }
    let modelNew = NumberScreenModel(
      rangeStartValue: model.rangeStartValue,
      rangeEndValue: model.rangeEndValue,
      result: model.result,
      listResult: model.listResult,
      isEnabledWithoutRepetition: isOn
    )
    storageService.numberScreenModel = modelNew
    getContent()
  }
  
  func getContent(withWithoutRepetition isOn: Bool = false) {
    configureModel(withWithoutRepetition: isOn)
  }
  
  func generateContent(firstTextFieldValue: String?,
                       secondTextFieldValue: String?) {
    let appearance = Appearance()
    
    let rangeStartValue = (firstTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
    let rangeStartValueNum = Int(rangeStartValue) ?? .zero
    
    let rangeEndValue = (secondTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
    let rangeEndValueNum = Int(rangeEndValue) ?? .zero
    
    guard rangeStartValueNum < rangeEndValueNum else {
      output?.didReceiveRangeError()
      return
    }
    let randomNumber = Int.random(in: rangeStartValueNum...rangeEndValueNum)
    var listResult: [String] = []
    
    if let model = storageService.numberScreenModel {
      listResult = model.listResult.map { $0.replacingOccurrences(of: appearance.withoutSpaces, with: "") }
    }
    
    // Срабатывает если включенно "Без повторений"
    if let model = storageService.numberScreenModel, model.isEnabledWithoutRepetition {
      guard let modelWithoutRepetition = generateContentWithoutRepetition(listResult: listResult,
                                                                          rangeStartValueNum: rangeStartValueNum,
                                                                          rangeEndValueNum: rangeEndValueNum) else {
        return
      }
      storageService.numberScreenModel = modelWithoutRepetition
      getContent()
    } else {
      listResult.append(String(randomNumber))
      
      let model = NumberScreenModel(
        rangeStartValue: formatter(text: rangeStartValue),
        rangeEndValue: formatter(text: rangeEndValue),
        result: formatter(text: String(randomNumber)) ?? "",
        listResult: listResult.map { formatter(text: String($0)) ?? "" },
        isEnabledWithoutRepetition: storageService.numberScreenModel?.isEnabledWithoutRepetition ?? false
      )
      storageService.numberScreenModel = model
      getContent()
    }
  }
  
  func rangeStartDidChange(_ text: String?) {
    let rangeStart = formatter(text: text)
    output?.didReceiveRangeStart(text: rangeStart)
  }
  
  func rangeEndDidChange(_ text: String?) {
    let rangeEnd = formatter(text: text)
    output?.didReceiveRangeEnd(text: rangeEnd)
  }
  
  func returnListResult() -> [String] {
    if let model = storageService.numberScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
  
  func returnModel() -> NumberScreenModel {
    let appearance = Appearance()
    if let model = storageService.numberScreenModel {
      return model
    } else {
      let model = NumberScreenModel(
        rangeStartValue: appearance.rangeStartValue,
        rangeEndValue: appearance.rangeEndValue,
        result: appearance.result,
        listResult: [],
        isEnabledWithoutRepetition: false
      )
      return model
    }
  }
}

// MARK: - Private

private extension NumberScreenInteractor {
  func generateContentWithoutRepetition(
    listResult: [String],
    rangeStartValueNum: Int,
    rangeEndValueNum: Int
  ) -> NumberScreenModel? {
    var randomNumber = Int.random(in: rangeStartValueNum...rangeEndValueNum)
    var listResult = listResult
    
    if listResult.count < rangeEndValueNum {
      while listResult.contains("\(randomNumber)") {
        randomNumber = Int.random(in: rangeStartValueNum...rangeEndValueNum)
      }
      listResult.append("\(randomNumber)")
      return NumberScreenModel(
        rangeStartValue: formatter(text: "\(rangeStartValueNum)"),
        rangeEndValue: formatter(text: "\(rangeEndValueNum)"),
        result: formatter(text: String(randomNumber)) ?? "",
        listResult: listResult.map { formatter(text: String($0)) ?? "" },
        isEnabledWithoutRepetition: storageService.numberScreenModel?.isEnabledWithoutRepetition ?? false
      )
    } else {
      output?.didReceiveRangeEnded()
      return nil
    }
  }
  
  func configureModel(withWithoutRepetition isOn: Bool) {
    if let model = storageService.numberScreenModel {
      output?.didReceive(model: model)
    } else {
      let appearance = Appearance()
      let model = NumberScreenModel(
        rangeStartValue: appearance.rangeStartValue,
        rangeEndValue: appearance.rangeEndValue,
        result: appearance.result,
        listResult: [],
        isEnabledWithoutRepetition: isOn
      )
      storageService.numberScreenModel = model
      output?.didReceive(model: model)
    }
  }
  
  func formatter(text: String?) -> String? {
    guard let text = text else {
      return nil
    }
    
    let appearance = Appearance()
    numberFormatter.numberStyle = .decimal
    numberFormatter.groupingSeparator = Appearance().withoutSpaces
    
    let textWithoutSpaces = text.replacingOccurrences(of: appearance.withoutSpaces, with: "")
    
    guard let textNumber = Int(textWithoutSpaces) else {
      return nil
    }
    
    let number = NSNumber(value: textNumber)
    let formatterNumber = numberFormatter.string(from: number)
    return formatterNumber
  }
}

// MARK: - Appearance

private extension NumberScreenInteractor {
  struct Appearance {
    let withoutSpaces = " "
    let rangeStartValue = "1"
    let rangeEndValue = "10"
    let result = "?"
  }
}
