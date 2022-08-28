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
  func didReciveModel(_ model: ListScreenModel)
  
  /// Была получена ошибка
  func didReciveError()
  
  /// Была получена ошибка об отсутствии элементов
  func didReciveIsEmptyError()
  
  /// Закончился диапазон уникальных элементов
  func didReciveRangeUniqueItemsError()
  
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
  
  @ObjectCustomUserDefaultsWrapper<ListScreenModel>(key: Appearance().keyUserDefaults)
  private var model: ListScreenModel?
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = model {
      output?.didReciveModel(model)
    } else {
      let newModel = Appearance().defaultModel
      self.model = newModel
      output?.didReciveModel(newModel)
    }
  }
  
  func returnCurrentModel() -> ListScreenModel {
    if let model = model {
      return model
    } else {
      return Appearance().defaultModel
    }
  }
  
  func updateContentWith(models: [ListScreenModel.TextModel]) {
    guard let model = model else {
      output?.didReciveError()
      return
    }
    let newModel = ListScreenModel(
      withoutRepetition: model.withoutRepetition,
      allItems: models,
      tempUniqueItems: model.tempUniqueItems,
      generetionItems: model.generetionItems,
      result: model.result
    )
    self.model = newModel
  }
  
  func updateWithoutRepetition(_ value: Bool) {
    guard let model = model else {
      output?.didReciveError()
      return
    }
    let newModel = ListScreenModel(
      withoutRepetition: value,
      allItems: model.allItems,
      tempUniqueItems: model.tempUniqueItems,
      generetionItems: model.generetionItems,
      result: model.result
    )
    self.model = newModel
  }
  
  func generateButtonAction() {
    guard let model = model else {
      output?.didReciveIsEmptyError()
      return
    }
    
    if model.withoutRepetition {
      let uniqueItems: [ListScreenModel.TextModel] = model.allItems.difference(from: model.tempUniqueItems)

      guard let randomItem = uniqueItems.shuffled().first else {
        output?.didReciveRangeUniqueItemsError()
        return
      }
      
      var generetionItems = model.generetionItems
      generetionItems.append(randomItem.text ?? "")
      
      var tempUniqueItems = model.tempUniqueItems
      tempUniqueItems.append(randomItem)
      
      if tempUniqueItems.count > model.allItems.count {
        output?.didReciveRangeUniqueItemsError()
      } else {
        let newModel = ListScreenModel(
          withoutRepetition: model.withoutRepetition,
          allItems: model.allItems,
          tempUniqueItems: tempUniqueItems,
          generetionItems: generetionItems,
          result: randomItem.text ?? ""
        )
        self.model = newModel
        output?.didReciveModel(newModel)
      }
    } else {
      guard let randomItem = model.allItems.shuffled().first else {
        output?.didReciveIsEmptyError()
        return
      }
      var generetionItems = model.generetionItems
      generetionItems.append(randomItem.text ?? "")
      
      var tempUniqueItems = model.tempUniqueItems
      tempUniqueItems.append(randomItem)
      
      let newModel = ListScreenModel(
        withoutRepetition: model.withoutRepetition,
        allItems: model.allItems,
        tempUniqueItems: tempUniqueItems,
        generetionItems: generetionItems,
        result: randomItem.text ?? ""
      )
      self.model = newModel
      output?.didReciveModel(newModel)
    }
  }
  
  func cleanButtonAction() {
    guard let model = model else {
      return
    }
    
    let newModel = ListScreenModel(
      withoutRepetition: model.withoutRepetition,
      allItems: model.allItems,
      tempUniqueItems: [],
      generetionItems: [],
      result: "?"
    )
    self.model = newModel
    output?.didReciveModel(newModel)
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

// MARK: - Appearance

private extension ListScreenInteractor {
  struct Appearance {
    let defaultModel = ListScreenModel(
      withoutRepetition: true,
      allItems: [],
      tempUniqueItems: [],
      generetionItems: [],
      result: "?"
    )
    let keyUserDefaults = "list_screen_user_defaults_key"
  }
}
