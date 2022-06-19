//
//  NumberScreenInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
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
}

protocol NumberScreenInteractorInput: AnyObject {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, без повторений
  ///  - Parameter model: Модель
  func withoutRepetition(model: NumberScreenModel)
  
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
  }
  
  func withoutRepetition(model: NumberScreenModel) {
    self.model = model
  }
  
  func getContent() {
    if let model = model {
      output?.didRecive(model: model)
    } else {
      let appearance = Appearance()
      let model = NumberScreenModel(
        rangeStartValue: appearance.rangeStartValue,
        rangeEndValue: appearance.rangeEndValue,
        result: appearance.result,
        listResult: [],
        isNoRepetition: false
      )
      output?.didRecive(model: model)
    }
  }
  
  func generateContent(firstTextFieldValue: String?,
                       secondTextFieldValue: String?) {
    let appearance = Appearance()
    
    let rangeStartValue = (firstTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
    let rangeStartValueNum = Int(rangeStartValue) ?? .zero
    
    let rangeEndValue = (secondTextFieldValue ?? "").replacingOccurrences(of: appearance.withoutSpaces, with: "")
    let rangeEndValueNum = Int(rangeEndValue) ?? .zero
    
    guard rangeStartValueNum < rangeEndValueNum else { return }
    let randomNumber = Int.random(in: rangeStartValueNum...rangeEndValueNum)
    let randomNumberFormatter = formatter(text: String(randomNumber)) ?? ""
    
    var listResult: [String] = []
    
    if let model = model {
      listResult = model.listResult
    }
    listResult.append(randomNumberFormatter)
    
    let model = NumberScreenModel(
      rangeStartValue: formatter(text: rangeStartValue),
      rangeEndValue: formatter(text: rangeEndValue),
      result: randomNumberFormatter,
      listResult: listResult,
      isNoRepetition: self.model?.isNoRepetition ?? false
    )
    self.model = model
    getContent()
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
  private func formatter(text: String?) -> String? {
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
