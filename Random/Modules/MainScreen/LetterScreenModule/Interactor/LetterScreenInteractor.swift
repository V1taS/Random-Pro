//
//  LetterScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LetterScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: LetterScreenModel)
  
  /// Диапазон букв закончился
  func didReceiveRangeEnded()
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: LetterScreenModel)
}

protocol LetterScreenInteractorInput: AnyObject {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Получить данные
  func getContent()
  
  /// Сoздать новые данные русских букв
  func generateContentRusLetter()
  
  /// Создать новые данные английских букв
  func generateContentEngLetter()
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
}

final class LetterScreenInteractor: LetterScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: LetterScreenInteractorOutput?
  
  // MARK: - Private property
  
  @ObjectCustomUserDefaultsWrapper<LetterScreenModel>(key: Appearance().keyUserDefaults)
  private var model: LetterScreenModel?
  
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
    
    let modelNew = LetterScreenModel(
      result: model.result,
      listResult: model.listResult,
      isEnabledWithoutRepetition: isOn,
      languageIndexSegmented: model.languageIndexSegmented
    )
    self.model = modelNew
    getContent()
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContentRusLetter() {
    let appearance = Appearance()
    guard let model = model else {
      configureModel()
      return
    }
    
    if model.isEnabledWithoutRepetition {
      guard let newModel = generateContentWithoutRepetitionWith(
        model: model,
        listLetter: appearance.listRussionLetter,
        languageIndexSegmented: appearance.rusControl
      ) else {
        configureModel()
        return
      }
      self.model = newModel
      output?.didReceive(model: newModel)
    } else {
      let newModel = generateRandomContent(model: model,
                                           listLetter: Appearance().listRussionLetter,
                                           languageIndexSegmented: appearance.rusControl)
      self.model = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func generateContentEngLetter() {
    let appearance = Appearance()
    guard let model = model else {
      assertionFailure("Неудалось получить модель")
      configureModel()
      return
    }
    
    if model.isEnabledWithoutRepetition {
      guard let newModel = generateContentWithoutRepetitionWith(
        model: model,
        listLetter: appearance.listEnglishLetter,
        languageIndexSegmented: appearance.engControl
      ) else {
        assertionFailure("Неудалось получить модель")
        configureModel()
        return
      }
      self.model = newModel
      output?.didReceive(model: newModel)
    } else {
      let newModel = generateRandomContent(model: model,
                                           listLetter: Appearance().listEnglishLetter,
                                           languageIndexSegmented: appearance.engControl)
      self.model = newModel
      output?.didReceive(model: newModel)
    }
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

private extension LetterScreenInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = model {
      output?.didReceive(model: model)
    } else {
      let appearance = Appearance()
      let model = LetterScreenModel(
        result: appearance.result,
        listResult: [],
        isEnabledWithoutRepetition: isOn,
        languageIndexSegmented: appearance.rusControl
      )
      self.model = model
      output?.didReceive(model: model)
    }
  }
  
  func generateRandomContent(model: LetterScreenModel,
                             listLetter: [String],
                             languageIndexSegmented: Int) -> LetterScreenModel {
    let result = listLetter.shuffled().first ?? ""
    var listResult = model.listResult
    listResult.append(result)
    
    return LetterScreenModel(
      result: result,
      listResult: listResult,
      isEnabledWithoutRepetition: model.isEnabledWithoutRepetition,
      languageIndexSegmented: languageIndexSegmented
    )
  }
  
  func generateContentWithoutRepetitionWith(model: LetterScreenModel,
                                            listLetter: [String],
                                            languageIndexSegmented: Int) -> LetterScreenModel? {
    var result = listLetter.shuffled().first ?? ""
    var listResult = model.listResult
    
    if listResult.count < listLetter.count {
      while listResult.contains("\(result)") {
        result = listLetter.shuffled().first ?? ""
      }
      listResult.append("\(result)")
      
      return LetterScreenModel(
        result: result,
        listResult: listResult,
        isEnabledWithoutRepetition: model.isEnabledWithoutRepetition,
        languageIndexSegmented: languageIndexSegmented
      )
    } else {
      output?.didReceiveRangeEnded()
      return nil
    }
  }
}

// MARK: - Appearance

private extension LetterScreenInteractor {
  struct Appearance {
    let result = "?"
    let listRussionLetter = [
      "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т",
      "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"
    ]
    let listEnglishLetter = [
      "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
      "U", "V", "W", "X", "Y", "Z"
    ]
    let keyUserDefaults = "letter_screen_user_defaults_key"
    let rusControl: Int = 0
    let engControl: Int = 1
  }
}
