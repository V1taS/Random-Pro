//
//  NumberScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol NumberScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(model: NumberScreenModel)
  
  /// Были получены данные
  ///  - Parameter text: Было получено начало диапазона
  func didReciveRangeStart(text: String?)
  
  /// Были получены данные
  ///  - Parameter text: Было получено конец диапазона
  func didReciveRangeEnd(text: String?)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: NumberScreenModel)
  
  /// Диапазон чисел закончился
  func didReciveRangeEnded()
  
  /// Неправильный диапазон чисел
  func didReciveRangeError()
}

protocol NumberScreenInteractorInput: AnyObject {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Получить данные
  func getContent()
  
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
  @ObjectCustomUserDefaultsWrapper<NumberScreenModel>(key: Appearance().keyUserDefaults)
  private var model: NumberScreenModel?
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    model = nil
    getContent()
    guard let model = model else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    guard let model = model else {
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
    self.model = modelNew
    getContent()
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContent(firstTextFieldValue: String?,
                       secondTextFieldValue: String?) {
    let appearance = Appearance()
    
    let rangeStartValue = (firstTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
    let rangeStartValueNum = Int(rangeStartValue) ?? .zero
    
    let rangeEndValue = (secondTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
    let rangeEndValueNum = Int(rangeEndValue) ?? .zero
    
    guard rangeStartValueNum < rangeEndValueNum else {
      output?.didReciveRangeError()
      return
    }
    let randomNumber = Int.random(in: rangeStartValueNum...rangeEndValueNum)
    var listResult: [String] = []
    
    if let model = model {
      listResult = model.listResult.map { $0.replacingOccurrences(of: appearance.withoutSpaces, with: "") }
    }
    
    // Срабатывает если включенно "Без повторений"
    if let model = model, model.isEnabledWithoutRepetition {
      guard let modelWithoutRepetition = generateContentWithoutRepetition(listResult: listResult,
                                                                          rangeStartValueNum: rangeStartValueNum,
                                                                          rangeEndValueNum: rangeEndValueNum) else {
        return
      }
      self.model = modelWithoutRepetition
      getContent()
    } else {
      listResult.append(String(randomNumber))
      
      let model = NumberScreenModel(
        rangeStartValue: formatter(text: rangeStartValue),
        rangeEndValue: formatter(text: rangeEndValue),
        result: formatter(text: String(randomNumber)) ?? "",
        listResult: listResult.map { formatter(text: String($0)) ?? "" },
        isEnabledWithoutRepetition: self.model?.isEnabledWithoutRepetition ?? false
      )
      self.model = model
      getContent()
    }
  }
  
  func rangeStartDidChange(_ text: String?) {
    let rangeStart = formatter(text: text)
    output?.didReciveRangeStart(text: rangeStart)
  }
  
  func rangeEndDidChange(_ text: String?) {
    let rangeEnd = formatter(text: text)
    output?.didReciveRangeEnd(text: rangeEnd)
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
        isEnabledWithoutRepetition: self.model?.isEnabledWithoutRepetition ?? false
      )
    } else {
      output?.didReciveRangeEnded()
      return nil
    }
  }
  
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = model {
      output?.didRecive(model: model)
    } else {
      let appearance = Appearance()
      let model = NumberScreenModel(
        rangeStartValue: appearance.rangeStartValue,
        rangeEndValue: appearance.rangeEndValue,
        result: appearance.result,
        listResult: [],
        isEnabledWithoutRepetition: isOn
      )
      self.model = model
      output?.didRecive(model: model)
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
    let keyUserDefaults = "number_screen_user_defaults_key"
  }
}
