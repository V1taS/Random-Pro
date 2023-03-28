//
//  ListScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ListScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: Моделька с данными
  func didReceiveModel(_ model: ListScreenModel)
  
  /// Была получена ошибка
  func didReceiveError()
  
  /// Была получена ошибка об отсутствии элементов
  func didReceiveIsEmptyError()
  
  /// Закончился диапазон уникальных элементов
  func didReceiveRangeUniqueItemsError()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем из Presenter к Interactor
protocol ListScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Возвращает текущей модели
  func returnCurrentModel() -> ListScreenModel
  
  /// Обновить контент
  ///  - Parameter models: Модельки с текстами
  func updateContentWith(models: [ListScreenModel.TextModel])
  
  /// Обновить контент
  ///  - Parameter value: Без повторений
  func updateWithoutRepetition(_ value: Bool)
  
  /// Кнопка генерации была нажата
  func generateButtonAction()
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

final class ListScreenInteractor: ListScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: ListScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: ListScreenStorageServiceProtocol
  private var listScreenModel: ListScreenModel? {
    get {
      storageService.getDataWith(key: Appearance().listScreenModelKeyUserDefaults,
                                 to: ListScreenModel.self)
    } set {
      storageService.saveData(newValue, key: Appearance().listScreenModelKeyUserDefaults)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(storageService: ListScreenStorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = listScreenModel {
      output?.didReceiveModel(model)
    } else {
      let newModel = ListScreenModel(
        withoutRepetition: true,
        allItems: generateFakeItems(),
        tempUniqueItems: [],
        generetionItems: [],
        result: Appearance().result
      )
      
      self.listScreenModel = newModel
      output?.didReceiveModel(newModel)
    }
  }
  
  func returnCurrentModel() -> ListScreenModel {
    if let model = listScreenModel {
      return model
    } else {
      return ListScreenModel(
        withoutRepetition: true,
        allItems: generateFakeItems(),
        tempUniqueItems: [],
        generetionItems: [],
        result: Appearance().result
      )
    }
  }
  
  func updateContentWith(models: [ListScreenModel.TextModel]) {
    guard let model = listScreenModel else {
      output?.didReceiveError()
      return
    }
    let newModel = ListScreenModel(
      withoutRepetition: model.withoutRepetition,
      allItems: models,
      tempUniqueItems: model.tempUniqueItems,
      generetionItems: model.generetionItems,
      result: model.result
    )
    self.listScreenModel = newModel
  }
  
  func updateWithoutRepetition(_ value: Bool) {
    guard let model = listScreenModel else {
      output?.didReceiveError()
      return
    }
    let newModel = ListScreenModel(
      withoutRepetition: value,
      allItems: model.allItems,
      tempUniqueItems: model.tempUniqueItems,
      generetionItems: model.generetionItems,
      result: model.result
    )
    self.listScreenModel = newModel
  }
  
  func generateButtonAction() {
    guard let model = listScreenModel else {
      output?.didReceiveIsEmptyError()
      return
    }
    let modelAllItems = model.allItems
    let modelTempUniqueItems = model.tempUniqueItems
    
    if model.withoutRepetition {
      let uniqueItems: [ListScreenModel.TextModel] = modelAllItems.difference(from: modelTempUniqueItems)
      
      guard let randomItem = uniqueItems.shuffled().first else {
        output?.didReceiveRangeUniqueItemsError()
        return
      }
      
      var generetionItems = model.generetionItems
      generetionItems.append(randomItem.text ?? "")
      
      var tempUniqueItems = modelTempUniqueItems
      tempUniqueItems.append(randomItem)
      
      if tempUniqueItems.count > model.allItems.count {
        output?.didReceiveRangeUniqueItemsError()
      } else {
        let newModel = ListScreenModel(
          withoutRepetition: model.withoutRepetition,
          allItems: modelAllItems,
          tempUniqueItems: tempUniqueItems,
          generetionItems: generetionItems,
          result: randomItem.text ?? ""
        )
        self.listScreenModel = newModel
        output?.didReceiveModel(newModel)
      }
    } else {
      guard let randomItem = modelAllItems.shuffled().first else {
        output?.didReceiveIsEmptyError()
        return
      }
      var generetionItems = model.generetionItems
      generetionItems.append(randomItem.text ?? "")
      
      var tempUniqueItems = modelTempUniqueItems
      tempUniqueItems.append(randomItem)
      
      let newModel = ListScreenModel(
        withoutRepetition: model.withoutRepetition,
        allItems: modelAllItems,
        tempUniqueItems: tempUniqueItems,
        generetionItems: generetionItems,
        result: randomItem.text ?? ""
      )
      self.listScreenModel = newModel
      output?.didReceiveModel(newModel)
    }
  }
  
  func cleanButtonAction() {
    guard let model = listScreenModel else {
      return
    }
    
    let modelAllItems = model.allItems
    let newModel = ListScreenModel(
      withoutRepetition: model.withoutRepetition,
      allItems: modelAllItems,
      tempUniqueItems: [],
      generetionItems: [],
      result: "?"
    )
    self.listScreenModel = newModel
    output?.didReceiveModel(newModel)
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Extension Array

private extension Array where Element: Hashable {
  func difference(from other: [Element]) -> [Element] {
    let thisSet = Set(self)
    let otherSet = Set(other)
    return Array(thisSet.symmetricDifference(otherSet))
  }
}

// MARK: - Private

private extension ListScreenInteractor {
  func generateFakeItems() -> [ListScreenModel.TextModel] {
    let secondStartApp = UserDefaults.standard.bool(forKey: Appearance().keySecondStartApp)
    let appearance = Appearance()
    guard !secondStartApp else {
      return []
    }
    UserDefaults.standard.set(true, forKey: Appearance().keySecondStartApp)
    
    let fakeList: [String] = [
      "\(appearance.football) ⚽️",
      "\(appearance.cleaning) 🧼",
      "\(appearance.walk) 🏃🏼‍♀️",
      "\(appearance.goOnDate) 🥰",
      "\(appearance.callYourParents) 🤳🏼"
    ]
    
    return fakeList.map {
      return ListScreenModel.TextModel(id: UUID().uuidString,
                                       text: $0)
    }
  }
}

// MARK: - Appearance

private extension ListScreenInteractor {
  struct Appearance {
    let keySecondStartApp = "list_screen_second_start_app_key"
    
    let result = "?"
    let football = NSLocalizedString("Футбол", comment: "")
    let cleaning = NSLocalizedString("Уборка", comment: "")
    let walk = NSLocalizedString("Прогулка", comment: "")
    let goOnDate = NSLocalizedString("Пойти на свидание", comment: "")
    let callYourParents = NSLocalizedString("Позвонить родителям", comment: "")
    let listScreenModelKeyUserDefaults = "list_screen_user_defaults_key"
  }
}
