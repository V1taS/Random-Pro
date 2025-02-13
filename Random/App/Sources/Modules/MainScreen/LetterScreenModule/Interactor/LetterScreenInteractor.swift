//
//  LetterScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

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

protocol LetterScreenInteractorInput {
  
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
  
  private var storageService: StorageService
  private let buttonCounterService: ButtonCounterService
  private var letterScreenModel: LetterScreenModel? {
    get {
      storageService.getData(from: LetterScreenModel.self)
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
    letterScreenModel = nil
    getContent()
    guard let model = letterScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    guard let model = letterScreenModel else {
      configureModel(withWithoutRepetition: isOn)
      return
    }
    
    let modelNew = LetterScreenModel(
      result: model.result,
      listResult: model.listResult,
      isEnabledWithoutRepetition: isOn,
      languageIndexSegmented: model.languageIndexSegmented
    )
    self.letterScreenModel = modelNew
    getContent()
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContentRusLetter() {
    let appearance = Appearance()
    guard let model = letterScreenModel else {
      configureModel()
      return
    }
    
    if model.isEnabledWithoutRepetition {
      guard let newModel = generateContentWithoutRepetitionWith(
        model: model,
        listLetter: appearance.listRussionLetters,
        languageIndexSegmented: appearance.russionCharacterIndex
      ) else {
        configureModel()
        return
      }
      self.letterScreenModel = newModel
      output?.didReceive(model: newModel)
    } else {
      let newModel = generateRandomContent(model: model,
                                           listLetter: Appearance().listRussionLetters,
                                           languageIndexSegmented: appearance.russionCharacterIndex)
      self.letterScreenModel = newModel
      output?.didReceive(model: newModel)
    }
    buttonCounterService.onButtonClick()
  }
  
  func generateContentEngLetter() {
    let appearance = Appearance()
    guard let model = letterScreenModel else {
      assertionFailure("Неудалось получить модель")
      configureModel()
      return
    }
    
    if model.isEnabledWithoutRepetition {
      guard let newModel = generateContentWithoutRepetitionWith(
        model: model,
        listLetter: appearance.listEnglishLetters,
        languageIndexSegmented: appearance.englishCharacterIndex
      ) else {
        assertionFailure("Неудалось получить модель")
        configureModel()
        return
      }
      self.letterScreenModel = newModel
      output?.didReceive(model: newModel)
    } else {
      let newModel = generateRandomContent(model: model,
                                           listLetter: Appearance().listEnglishLetters,
                                           languageIndexSegmented: appearance.englishCharacterIndex)
      self.letterScreenModel = newModel
      output?.didReceive(model: newModel)
    }
  }
  
  func returnListResult() -> [String] {
    if let model = letterScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
}

// MARK: - Private

private extension LetterScreenInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = letterScreenModel {
      output?.didReceive(model: model)
    } else {
      let appearance = Appearance()
      let model = LetterScreenModel(
        result: appearance.result,
        listResult: [],
        isEnabledWithoutRepetition: isOn,
        languageIndexSegmented: appearance.russionCharacterIndex
      )
      self.letterScreenModel = model
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
    let listRussionLetters = [
      "А", "Б", "В", "Г", "Д", "Е", "Ё", "Ж", "З", "И", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т",
      "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ъ", "Ы", "Ь", "Э", "Ю", "Я"
    ]
    let listEnglishLetters = [
      "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
      "U", "V", "W", "X", "Y", "Z"
    ]
    let russionCharacterIndex: Int = 0
    let englishCharacterIndex: Int = 1
  }
}
