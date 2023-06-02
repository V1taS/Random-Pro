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
  
  /// Была получена ошибка из-за слишком короткой длины пароля
  func didReceiveErrorWithCountOfCharacters()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Было получено время взлома  и силу пароля в слайдере
  /// - Parameters:
  ///  - text: Текст с количеством дней
  ///  - strengthValue: Сила пароля
  func didReceiveCrackTime(text: String, strengthValue: Float)
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
  
  /// Расчитать время взлома пароля
  /// - Parameter password: Пароль
  func calculateCrackTime(password: String)
}

final class PasswordScreenInteractor: PasswordScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: PasswordScreenInteractorOutput?
  
  // MARK: - Private property
  
  private lazy var numberFormatter = NumberFormatter()
  private var storageService: StorageService
  private let buttonCounterService: ButtonCounterService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
    buttonCounterService = services.buttonCounterService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = storageService.passwordScreenModel {
      let newModel = PasswordScreenModel(
        passwordLength: model.passwordLength,
        result: model.result,
        listResult: model.listResult,
        switchState: model.switchState
      )
      self.storageService.passwordScreenModel = newModel
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
      self.storageService.passwordScreenModel = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func passwordLengthDidChange(_ text: String?) {
    let rangeStart = formatter(text: text)
    output?.didReceivePasswordLength(text: rangeStart)
    
    guard let model = storageService.passwordScreenModel else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: text,
      result: model.result,
      listResult: model.listResult,
      switchState: model.switchState
    )
    self.storageService.passwordScreenModel = newModel
  }
  
  func uppercaseSwitchAction(status: Bool) {
    guard let model = storageService.passwordScreenModel else {
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
    self.storageService.passwordScreenModel = newModel
  }
  
  func lowercaseSwitchAction(status: Bool) {
    guard let model = storageService.passwordScreenModel else {
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
    self.storageService.passwordScreenModel = newModel
  }
  
  func numbersSwitchAction(status: Bool) {
    guard let model = storageService.passwordScreenModel else {
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
    self.storageService.passwordScreenModel = newModel
  }
  
  func symbolsSwitchAction(status: Bool) {
    guard let model = storageService.passwordScreenModel else {
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
    self.storageService.passwordScreenModel = newModel
  }
  
  func generateButtonAction(passwordLength: String?) {
    guard
      let model = storageService.passwordScreenModel,
      let passwordLengthInt = Int((passwordLength ?? "").replacingOccurrences(of: Appearance().withoutSpaces, with: ""))
    else {
      output?.didReceiveErrorWithCountOfCharacters()
      return
    }
    buttonCounterService.onButtonClick()
    
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
        self.storageService.passwordScreenModel = newModel
        self.output?.didReceive(model: newModel)
      }
    )
  }
  
  func returnCurrentModel() -> PasswordScreenModel {
    if let model = storageService.passwordScreenModel {
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
    self.storageService.passwordScreenModel = newModel
    output?.didReceive(model: newModel)
    output?.cleanButtonWasSelected()
  }
  
  func calculateCrackTime(password: String) {
    calculateCrackTime(password: password) { [weak self] result in
      guard let self = self else {
        return
      }

      let strengthValue = self.getStrengthValue(for: result)
      let countTimeText: String

      switch result {
      case let .days(value):
        countTimeText = RandomStrings.Localizable.daysCount(value)
      case let .months(value):
        countTimeText = RandomStrings.Localizable.monthsCount(value)
      case let .years(value):
        countTimeText = RandomStrings.Localizable.yearsCount(value)
      case let .centuries(value):
        countTimeText = RandomStrings.Localizable.centuryCount(value)
      case let .overmuch(value):
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        let formattedValue = (formatter.string(from: NSNumber(value: value))) ?? ""
        countTimeText = "\(formattedValue) \(RandomStrings.Localizable.centuries)"
      }
      
      let replacedDotTimeText = countTimeText.replacingOccurrences(of: ".", with: " ")
      let replacedCommaTimeText = replacedDotTimeText.replacingOccurrences(of: ",", with: " ")
      let replacedDashTimeText = replacedCommaTimeText.replacingOccurrences(of: "-", with: "")
      let crackTimeText = "\(RandomStrings.Localizable.crackTime): \n\(replacedDashTimeText)"
      self.output?.didReceiveCrackTime(text: crackTimeText, strengthValue: strengthValue)
    }
  }
}

// MARK: - Private

private extension PasswordScreenInteractor {
  func getStrengthValue(for passwordCrackTimeType: PasswordScreenCrackTimeType) -> Float {

    switch passwordCrackTimeType {
    case let .days(value):
      return 0.1 + Float(value) / 300
    case let .months(value):
      return 0.2 + Float(value) / 60
    case let .years(value):
      return 0.4 + Float(value) / 250
    case let .centuries(value):
      return value < 139_999
      ? 0.8 + (Float(value) / 700_000)
      : 1
    case .overmuch:
      return 1
    }
  }

  func calculateCrackTime(password: String, completion: @escaping (PasswordScreenCrackTimeType) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async {
      let passwordLength = Double(password.count)
      // количество уникальных символов в пароле
      var charsetSize = Double(Set(password).count)
      // средняя скорость взлома
      let attemptsPerSecond = 10_000_000.0
      
      // Проверка на наличие различных типов символов
      let hasLowercase = password.rangeOfCharacter(from: .lowercaseLetters)
      let hasUppercase = password.rangeOfCharacter(from: .uppercaseLetters)
      let hasDigits = password.rangeOfCharacter(from: .decimalDigits)
      let hasSpecialCharacters = password.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted)
      
      // Увеличиваем общее количество символов на основе этих критериев
      if hasLowercase != nil { charsetSize += 26 }
      if hasUppercase != nil { charsetSize += 26 }
      if hasDigits != nil { charsetSize += 10 }
      // предполагаем, что доступно 32 специальных символа
      if hasSpecialCharacters != nil { charsetSize += 32 }
      let possibleCombinations = pow(charsetSize, passwordLength)
      let seconds = possibleCombinations / attemptsPerSecond
      let days = seconds / (60 * 60 * 24)
      
      DispatchQueue.main.async {
        if days <= 30 {
          completion(.days(lround(days)))
        } else {
          
          let months = days / 30
          if months <= 12 {
            completion(.months(lround(months)))
          } else {
            let years = months / 12
            if years > 100 {
              let centuries = years / 100
              if centuries > 922_337_203_685_477 {
                completion(.overmuch(lround(centuries)))
              } else {
                completion(.centuries(lround(centuries)))
              }
            } else {
              completion(.years(lround(years)))
            }
          }
        }
      }
    }
  }
  
  func generatePassword(capitalLetters: Bool,
                        numbers: Bool,
                        lowerCase: Bool,
                        symbols: Bool,
                        passwordLength: Int,
                        completion: @escaping (String) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard passwordLength >= 4 else {
        DispatchQueue.main.async {
          self?.output?.didReceiveErrorWithCountOfCharacters()
        }
        return
      }
      
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
    let passwordLength = "7"
  }
}
