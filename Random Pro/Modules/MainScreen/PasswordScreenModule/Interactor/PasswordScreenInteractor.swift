//
//  PasswordScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol PasswordScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter text: Было получено начало диапазона
  func didReceivePasswordLength(text: String?)
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: PasswordScreenModel)
  
  /// Была получена ошибка
  func didReceiveError()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol PasswordScreenInteractorInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> PasswordScreenModel
  
  /// Переключатель прописных букв
  ///  - Parameter status: Статус прописных букв
  func uppercaseSwitchAction(status: Bool)
  
  /// Переключатель строчных букв
  ///  - Parameter status: Статус строчных букв
  func lowercaseSwitchAction(status: Bool)
  
  /// Переключатель цифр
  ///  - Parameter status: Статус цифр
  func numbersSwitchAction(status: Bool)
  
  /// Переключатель символов
  ///  - Parameter status: Статус символов
  func symbolsSwitchAction(status: Bool)
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func passwordLengthDidChange(_ text: String?)
  
  /// Получить данные
  func getContent()
  
  /// Кнопка нажата пользователем
  /// - Parameter passwordLength: Длина пароля
  func generateButtonAction(passwordLength: String?)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

final class PasswordScreenInteractor: PasswordScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: PasswordScreenInteractorOutput?
  
  // MARK: - Private property
  
  private lazy var numberFormatter = NumberFormatter()
  @ObjectCustomUserDefaultsWrapper<PasswordScreenModel>(key: Appearance().keyUserDefaults)
  private var model: PasswordScreenModel?
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = model {
      let newModel = PasswordScreenModel(
        passwordLength: model.passwordLength,
        result: model.result,
        listResult: model.listResult,
        switchState: model.switchState
      )
      self.model = newModel
      output?.didReceive(model: newModel)
    } else {
      let appearance = Appearance()
      let newModel = PasswordScreenModel(
        passwordLength: appearance.passwordLength,
        result: appearance.resultLabel,
        listResult: [],
        switchState: PasswordScreenModel.SwitchState(
          uppercase: true,
          lowercase: true,
          numbers: true,
          symbols: true
        )
      )
      self.model = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func passwordLengthDidChange(_ text: String?) {
    let rangeStart = formatter(text: text)
    output?.didReceivePasswordLength(text: rangeStart)
    
    guard let model = model else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: text,
      result: model.result,
      listResult: model.listResult,
      switchState: model.switchState
    )
    self.model = newModel
  }
  
  func uppercaseSwitchAction(status: Bool) {
    guard let model = model else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: model.passwordLength,
      result: model.result,
      listResult: model.listResult,
      switchState: PasswordScreenModel.SwitchState(
        uppercase: status,
        lowercase: model.switchState.lowercase,
        numbers: model.switchState.numbers,
        symbols: model.switchState.symbols
      )
    )
    self.model = newModel
  }
  
  func lowercaseSwitchAction(status: Bool) {
    guard let model = model else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: model.passwordLength,
      result: model.result,
      listResult: model.listResult,
      switchState: PasswordScreenModel.SwitchState(
        uppercase: model.switchState.uppercase,
        lowercase: status,
        numbers: model.switchState.numbers,
        symbols: model.switchState.symbols
      )
    )
    self.model = newModel
  }
  
  func numbersSwitchAction(status: Bool) {
    guard let model = model else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: model.passwordLength,
      result: model.result,
      listResult: model.listResult,
      switchState: PasswordScreenModel.SwitchState(
        uppercase: model.switchState.uppercase,
        lowercase: model.switchState.lowercase,
        numbers: status,
        symbols: model.switchState.symbols
      )
    )
    self.model = newModel
  }
  
  func symbolsSwitchAction(status: Bool) {
    guard let model = model else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: model.passwordLength,
      result: model.result,
      listResult: model.listResult,
      switchState: PasswordScreenModel.SwitchState(
        uppercase: model.switchState.uppercase,
        lowercase: model.switchState.lowercase,
        numbers: model.switchState.numbers,
        symbols: status
      )
    )
    self.model = newModel
  }
  
  func generateButtonAction(passwordLength: String?) {
    guard
      let model = model,
      let passwordLengthInt = Int((passwordLength ?? "").replacingOccurrences(of: Appearance().withoutSpaces, with: ""))
    else {
      output?.didReceiveError()
      return
    }
    
    generatePassword(
      capitalLetters: model.switchState.uppercase,
      numbers: model.switchState.numbers,
      lowerCase: model.switchState.lowercase,
      symbols: model.switchState.symbols,
      passwordLength: passwordLengthInt,
      completion: { [weak self] password in
        guard let self = self else {
          return
        }
        
        var listResult: [String] = model.listResult
        listResult.append(password)
        
        let newModel = PasswordScreenModel(
          passwordLength: self.formatter(text: passwordLength),
          result: password,
          listResult: listResult,
          switchState: PasswordScreenModel.SwitchState(
            uppercase: model.switchState.uppercase,
            lowercase: model.switchState.lowercase,
            numbers: model.switchState.numbers,
            symbols: model.switchState.symbols
          )
        )
        self.model = newModel
        self.output?.didReceive(model: newModel)
      }
    )
  }
  
  func returnCurrentModel() -> PasswordScreenModel {
    if let model = model {
      return model
    } else {
      let appearance = Appearance()
      return PasswordScreenModel(
        passwordLength: appearance.passwordLength,
        result: appearance.resultLabel,
        listResult: [],
        switchState: PasswordScreenModel.SwitchState(
          uppercase: true,
          lowercase: true,
          numbers: true,
          symbols: true
        )
      )
    }
  }
  
  func cleanButtonAction() {
    let appearance = Appearance()
    let newModel = PasswordScreenModel(
      passwordLength: appearance.passwordLength,
      result: appearance.resultLabel,
      listResult: [],
      switchState: PasswordScreenModel.SwitchState(
        uppercase: true,
        lowercase: true,
        numbers: true,
        symbols: true
      )
    )
    self.model = newModel
    output?.didReceive(model: newModel)
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Private

private extension PasswordScreenInteractor {
  func generatePassword(capitalLetters: Bool,
                        numbers: Bool,
                        lowerCase: Bool,
                        symbols: Bool,
                        passwordLength: Int,
                        completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      guard passwordLength >= 4 else { return }
      
      var resultCharacters: [Character] = []
      
      var capitalLettersNew = capitalLetters
      var numbersNew = numbers
      var lowerCaseNew = lowerCase
      var symbolsNew = symbols
      
      let capitalLettersRaw = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      let numbersRaw = "0123456789"
      let lowerCaseRaw = "abcdefghijklmnopqrstuvwxyz"
      let symbolsRaw = "!@#$%^&*()"
      let reservRaw = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()"
      
      for _ in 1...passwordLength {
        if capitalLettersNew == false &&
            numbersNew == false &&
            lowerCaseNew == false &&
            symbolsNew == false {
          
          capitalLettersNew = capitalLetters
          numbersNew = numbers
          lowerCaseNew = lowerCase
          symbolsNew = symbols
        }
        
        if capitalLettersNew {
          resultCharacters.append(capitalLettersRaw.randomElement() ?? "T")
          capitalLettersNew = false
          continue
        }
        
        if numbersNew {
          resultCharacters.append(numbersRaw.randomElement() ?? "0")
          numbersNew = false
          continue
        }
        
        if lowerCaseNew {
          resultCharacters.append(lowerCaseRaw.randomElement() ?? "t")
          lowerCaseNew = false
          continue
        }
        
        if symbolsNew {
          resultCharacters.append(symbolsRaw.randomElement() ?? "!")
          symbolsNew = false
          continue
        }
        resultCharacters.append(reservRaw.randomElement() ?? "#")
      }
      let resultShuffled = String(resultCharacters.shuffled())
      DispatchQueue.main.async {
        completion(resultShuffled)
      }
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

private extension PasswordScreenInteractor {
  struct Appearance {
    let withoutSpaces = " "
    let resultLabel = "?"
    let passwordLength = "100"
    let keyUserDefaults = "password_screen_user_defaults_key"
  }
}
