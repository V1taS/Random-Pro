//
//  DateTimeInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol DateTimeInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: DateTimeScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: DateTimeScreenModel)
}

protocol DateTimeInteractorInput {
  
  /// Возвращает основную модель данных
  func returnModel() -> DateTimeScreenModel
  
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
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    storageService.dateTimeScreenModel = nil
    getContent()
    guard let model = storageService.dateTimeScreenModel else { return }
    output?.cleanButtonWasSelected(model: model)
  }
  
  func getContent() {
    configureModel()
  }
  
  func generateContentDate() {
    guard let model = storageService.dateTimeScreenModel else {
      return
    }
    
    let randomDate = Appearance().randomDate
    var listResult = model.listResult
    listResult.append("\(randomDate)")
    
    let newModel = DateTimeScreenModel(
      result: "\(randomDate)",
      listResult: listResult
    )
    
    self.storageService.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func generateContentTime() {
    guard let model = storageService.dateTimeScreenModel else {
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
    
    self.storageService.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func generateContentDay() {
    guard let model = storageService.dateTimeScreenModel else {
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
    
    self.storageService.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func generateContentMonth() {
    guard let model = storageService.dateTimeScreenModel else {
      return
    }
    
    let randomElementMonth = Appearance().listMonths.shuffled().first ?? ""
    var listResult = model.listResult
    listResult.append(randomElementMonth)
    
    let newModel = DateTimeScreenModel(
      result: randomElementMonth,
      listResult: listResult
    )
    
    self.storageService.dateTimeScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func returnListResult() -> [String] {
    if let model = storageService.dateTimeScreenModel {
      return model.listResult
    } else {
      return []
    }
  }
  
  func returnModel() -> DateTimeScreenModel {
    let appearance = Appearance()
    if let model = storageService.dateTimeScreenModel {
      return model
    } else {
      let model = DateTimeScreenModel(result: appearance.result, listResult: appearance.listDays)
      return model
    }
  }
}

// MARK: - Private

private extension DateTimeInteractor {
  func configureModel(withWithoutRepetition isOn: Bool = false) {
    if let model = storageService.dateTimeScreenModel {
      output?.didReceive(model: model)
    } else {
      let model = DateTimeScreenModel(
        result: Appearance().result,
        listResult: []
      )
      self.storageService.dateTimeScreenModel = model
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
      NSLocalizedString("Понедельник", comment: ""),
      NSLocalizedString("Вторник", comment: ""),
      NSLocalizedString("Среда", comment: ""),
      NSLocalizedString("Четверг", comment: ""),
      NSLocalizedString("Пятница", comment: ""),
      NSLocalizedString("Суббота", comment: ""),
      NSLocalizedString("Воскресенье", comment: "")
    ]
    
    let listMonths = [
      NSLocalizedString("Январь", comment: ""),
      NSLocalizedString("Февраль", comment: ""),
      NSLocalizedString("Март", comment: ""),
      NSLocalizedString("Апрель", comment: ""),
      NSLocalizedString("Май", comment: ""),
      NSLocalizedString("Июнь", comment: ""),
      NSLocalizedString("Июль", comment: ""),
      NSLocalizedString("Август", comment: ""),
      NSLocalizedString("Сентябрь", comment: ""),
      NSLocalizedString("Октябрь", comment: ""),
      NSLocalizedString("Ноябрь", comment: ""),
      NSLocalizedString("Декабрь", comment: ""),
    ]
  }
}
