//
//  DateTimeInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

protocol DateTimeInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: DateTimeScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: DateTimeScreenModel)
}

protocol DateTimeInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Создать новые данные date
  func generateContentDate()
  
  /// Создать новые данные time
  func generateContentTime()
  
  /// Создать новые данные day
  func generateContentDay()
  
  /// Создать новые данные month
  func generateContentMonth()
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
}

final class DateTimeInteractor: DateTimeInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: DateTimeInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  private let buttonCounterService: ButtonCounterService
  private var dateTimeScreenModel: DateTimeScreenModel? {
    get {
      storageService.getData(from: DateTimeScreenModel.self)
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
    dateTimeScreenModel = nil
    getContent()
    guard let model = dateTimeScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContentDate() {
    guard let model = dateTimeScreenModel else {
      return
    }
    
    let randomDate = Appearance().randomDate
    var listResult = model.listResult
    listResult.append("\(randomDate)")
    
    let newModel = DateTimeScreenModel(
      result: "\(randomDate)",
      listResult: listResult
    )
    
    self.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
    buttonCounterService.onButtonClick()
  }
  
  func generateContentTime() {
    guard let model = dateTimeScreenModel else {
      return
    }
    
    let appearance = Appearance()
    var listResult = model.listResult
    let randomTime = "\(appearance.randomTimeHours):\(appearance.randomTimeMinets)"
    listResult.append(randomTime)
    
    let newModel = DateTimeScreenModel(
      result: randomTime,
      listResult: listResult
    )
    
    self.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
    buttonCounterService.onButtonClick()
  }
  
  func generateContentDay() {
    guard let model = dateTimeScreenModel else {
      return
    }
    
    let appearance = Appearance()
    var listResult = model.listResult
    let randomElementDay = appearance.listDays.shuffled().first ?? ""
    listResult.append(randomElementDay)
    
    let newModel = DateTimeScreenModel(
      result: randomElementDay,
      listResult: listResult
    )
    
    self.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
    buttonCounterService.onButtonClick()
  }
  
  func generateContentMonth() {
    guard let model = dateTimeScreenModel else {
      return
    }
    
    let randomElementMonth = Appearance().listMonths.shuffled().first ?? ""
    var listResult = model.listResult
    listResult.append(randomElementMonth)
    
    let newModel = DateTimeScreenModel(
      result: randomElementMonth,
      listResult: listResult
    )
    
    self.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
    buttonCounterService.onButtonClick()
  }
  
  func returnListResult() -> [String] {
    if let model = dateTimeScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
}

// MARK: - Private

private extension DateTimeInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = dateTimeScreenModel {
      output?.didReceive(model: model)
    } else {
      let model = DateTimeScreenModel(
        result: Appearance().result,
        listResult: []
      )
      self.dateTimeScreenModel = model
      output?.didReceive(model: model)
    }
  }
}

// MARK: - Private Appearance

private extension DateTimeInteractor {
  struct Appearance {
    let result = "?"
    let randomTimeHours = Int.random(in: 1...12)
    let randomTimeMinets = Int.random(in: 1...59)
    let randomDate = Int.random(in: 1...30)
    let listDays = [
      RandomStrings.Localizable.monday,
      RandomStrings.Localizable.tuesday,
      RandomStrings.Localizable.wednesday,
      RandomStrings.Localizable.thursday,
      RandomStrings.Localizable.friday,
      RandomStrings.Localizable.saturday,
      RandomStrings.Localizable.sunday
    ]
    
    let listMonths = [
      RandomStrings.Localizable.january,
      RandomStrings.Localizable.february,
      RandomStrings.Localizable.march,
      RandomStrings.Localizable.april,
      RandomStrings.Localizable.may,
      RandomStrings.Localizable.june,
      RandomStrings.Localizable.july,
      RandomStrings.Localizable.august,
      RandomStrings.Localizable.september,
      RandomStrings.Localizable.october,
      RandomStrings.Localizable.november,
      RandomStrings.Localizable.december
    ]
  }
}
