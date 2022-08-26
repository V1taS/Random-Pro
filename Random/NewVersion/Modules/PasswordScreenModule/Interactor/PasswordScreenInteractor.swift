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
  func didRecivePasswordLength(text: String?)
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(model: PasswordScreenModel)
  
  /// Была получена ошибка
  func didReciveError()
  
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
  
  /// Текст в текстовом поле был изменен
  /// - Parameters:
  ///  - text: Значение для текстового поля
  func rangePhraseDidChange(_ text: String?)
  
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
        resultClassic:  model.resultClassic,
        resultPhrase:  "",
        listResult: model.listResult,
        switchState: model.switchState
      )
      self.model = newModel
      output?.didRecive(model: newModel)
    } else {
      let appearance = Appearance()
      let newModel = PasswordScreenModel(
        passwordLength: appearance.passwordLength,
        resultClassic:  appearance.resultLabel,
        resultPhrase:  appearance.resultLabel,
        listResult: [],
        switchState: PasswordScreenModel.SwitchState(
          uppercase: true,
          lowercase: true,
          numbers: true,
          symbols: true
        )
      )
      self.model = newModel
      output?.didRecive(model: newModel)
    }
  }
  
  func passwordLengthDidChange(_ text: String?) {
    let rangeStart = formatter(text: text)
    output?.didRecivePasswordLength(text: rangeStart)
    
    guard let model = model else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: text,
      resultClassic: model.resultClassic,
      resultPhrase: model.resultPhrase,
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
      resultClassic: model.resultClassic,
      resultPhrase: model.resultPhrase,
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
      resultClassic: model.resultClassic,
      resultPhrase: model.resultPhrase,
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
      resultClassic: model.resultClassic,
      resultPhrase: model.resultPhrase,
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
      resultClassic: model.resultClassic,
      resultPhrase: model.resultPhrase,
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
  
  func rangePhraseDidChange(_ text: String?) {
    guard
      let model = model,
      let text = text
    else {
      return
    }
    
    let newModel = PasswordScreenModel(
      passwordLength: model.passwordLength,
      resultClassic: model.resultClassic,
      resultPhrase: encrypt(text: text),
      listResult: model.listResult,
      switchState: model.switchState
      )
    self.model = newModel
    output?.didRecive(model: newModel)
  }
  
  func generateButtonAction(passwordLength: String?) {
    guard
      let model = model,
      let passwordLengthInt = Int((passwordLength ?? "").replacingOccurrences(of: Appearance().withoutSpaces, with: ""))
    else {
      output?.didReciveError()
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
          resultClassic: password,
          resultPhrase: model.resultPhrase,
          listResult: listResult,
          switchState: PasswordScreenModel.SwitchState(
            uppercase: model.switchState.uppercase,
            lowercase: model.switchState.lowercase,
            numbers: model.switchState.numbers,
            symbols: model.switchState.symbols
          )
        )
        self.model = newModel
        self.output?.didRecive(model: newModel)
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
        resultClassic:  appearance.resultLabel,
        resultPhrase:  appearance.resultLabel,
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
      resultClassic:  appearance.resultLabel,
      resultPhrase:  appearance.resultLabel,
      listResult: [],
      switchState: PasswordScreenModel.SwitchState(
        uppercase: true,
        lowercase: true,
        numbers: true,
        symbols: true
      )
    )
    self.model = newModel
    output?.didRecive(model: newModel)
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
  
  func encrypt(text: String) -> String {
    let textLowercased = text.lowercased().components(
      separatedBy:.whitespacesAndNewlines
    ).filter { $0.count > .zero }.joined(separator: " ")
    var encryptText = ""
    
    for character in textLowercased {
      encryptText += define(character)
    }
    return encryptText
  }
  
  func define(_ character: Character) -> String {
    var pass = ""
    
    switch character {
      // MARK: - Кириллица
    case "а":
      pass = "cZ9="
    case "б":
      pass = "5&lR"
    case "в":
      pass = ".1Rk"
    case "г":
      pass = "&x1K"
    case "д":
      pass = "Mz*7"
    case "е", "ё":
      pass = "Q;5n"
    case "ж":
      pass = "mQ9["
    case "з":
      pass = "5Qm."
    case "и":
      pass = "(uE8"
    case "й":
      pass = "9Op{"
    case "к":
      pass = "4Yp)"
    case "л":
      pass = "^P1z"
    case "м":
      pass = "4aC%"
    case "н":
      pass = "^h1D"
    case "о":
      pass = "z;N8"
    case "п":
      pass = "5^qJ"
    case "р":
      pass = "~7Mz"
    case "с":
      pass = "0f`N"
    case "т":
      pass = "7+Xy"
    case "у":
      pass = ">0Jh"
    case "ф":
      pass = "E{8h"
    case "х":
      pass = "I4m{"
    case "ц":
      pass = "|w4C"
    case "ч":
      pass = "8d.B"
    case "ш":
      pass = "1Uq)"
    case "щ":
      pass = "@7Gj"
    case "ъ":
      pass = "uR*8"
    case "ы":
      pass = "l'O4"
    case "ь":
      pass = "R4?n"
    case "э":
      pass = "5N>o"
    case "ю":
      pass = "b:L2"
    case "я":
      pass = "W|1q"
      
      // MARK: - Латиница
    case "a":
      pass = "Vj4;"
    case "b":
      pass = "4Ik{"
    case "c":
      pass = "9b]X"
    case "d":
      pass = "{C0p"
    case "e":
      pass = "+4Ca"
    case "f":
      pass = "T2r*"
    case "g":
      pass = "m%T5"
    case "h":
      pass = "!Ks7"
    case "i":
      pass = "}Eo1"
    case "j":
      pass = "}2gE"
    case "k":
      pass = "Bj8^"
    case "l":
      pass = "5o!E"
    case "m":
      pass = "$1Ho"
    case "n":
      pass = "0g}H"
    case "o":
      pass = ".W8r"
    case "p":
      pass = ">kV5"
    case "q":
      pass = "F`l5"
    case "r":
      pass = "b5T:"
    case "s":
      pass = "7d{A"
    case "t":
      pass = "y2E#"
    case "u":
      pass = "a!7E"
    case "v":
      pass = "Yz&0"
    case "w":
      pass = "$tW8"
    case "x":
      pass = "0f]Z"
    case "y":
      pass = "|Z0x"
    case "z":
      pass = "%qE3"
      
      // MARK: - Цифры
    case "0":
      pass = "l4$J"
    case "1":
      pass = "4]xX"
    case "2":
      pass = "1Fw#"
    case "3":
      pass = "8gP{"
    case "4":
      pass = "y!1I"
    case "5":
      pass = "Go8!"
    case "6":
      pass = "G9l="
    case "7":
      pass = "Fj4("
    case "8":
      pass = "l2%S"
    case "9":
      pass = "(g5L"
      
      // MARK: - Цифры
    case ".":
      pass = "Ol5)"
    case ",":
      pass = "aA8+"
    case "?":
      pass = "pN6#"
    case "'":
      pass = "B.3x"
    case "!":
      pass = "x]4X"
    case "/":
      pass = "+B6u"
    case "(":
      pass = "W2:w"
    case ")":
      pass = "&Oe4"
    case "&":
      pass = "Eo5="
    case ":":
      pass = "3i(F"
    case ";":
      pass = "7rO@"
    case "=":
      pass = "?r2J"
    case "+":
      pass = "[0fS"
    case "-":
      pass = "|2Ga"
    case "_":
      pass = "Q:6y"
    case "\"":
      pass = "'c9P"
    case "$":
      pass = "6qJ$"
    case "@":
      pass = "Rh8^"
    case "¿":
      pass = "5+mY"
    case "¡":
      pass = "E;k8"
      
      // MARK: - default
    default:
      pass = ""
    }
    return pass
  }
}

// MARK: - Appearance

private extension PasswordScreenInteractor {
  struct Appearance {
    let withoutSpaces = " "
    let resultLabel = "?"
    let passwordLength = "20"
    let keyUserDefaults = "password_screen_user_defaults_key"
  }
}
