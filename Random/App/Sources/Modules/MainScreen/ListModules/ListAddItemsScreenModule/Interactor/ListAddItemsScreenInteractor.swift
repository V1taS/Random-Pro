//
//  ListAddItemsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ListAddItemsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: Модельки с текстами
  func didReceiveText(models: [ListAddItemsScreenModel.TextModel])
}

/// События которые отправляем от Presenter к Interactor
protocol ListAddItemsScreenInteractorInput {
  
  /// Возвращает текущий список моделек с текстом
  func returnCurrentListTextModel() -> [ListAddItemsScreenModel.TextModel]
  
  /// Обновить контент
  ///  - Parameter models: Модельки с текстами
  func updateContentWith(models: [ListAddItemsScreenModel.TextModel])
  
  /// Получить данные
  func getContent()
  
  /// Добавить текст
  ///  - Parameter text: Текст
  func textAdd(_ text: String?)
  
  /// Удалить текст
  ///  - Parameter id: Уникальный номер текста
  func textRemove(id: String)
  
  /// Удалить все элементы
  func removeAllText()
}

/// Интерактор
final class ListAddItemsScreenInteractor: ListAddItemsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ListAddItemsScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private var models: [ListAddItemsScreenModel.TextModel] = []
  
  // MARK: - Internal func
  
  func getContent() {
    output?.didReceiveText(models: models)
  }
  
  func updateContentWith(models: [ListAddItemsScreenModel.TextModel]) {
    self.models = models
  }
  
  func returnCurrentListTextModel() -> [ListAddItemsScreenModel.TextModel] {
    return models
  }
  
  func textAdd(_ text: String?) {
    guard
      let text = text,
      !text.isEmpty
    else {
      return
    }
    
    let textModel = ListAddItemsScreenModel.TextModel(
      id: UUID().uuidString,
      text: text
    )
    
    models.append(textModel)
    output?.didReceiveText(models: models)
  }
  
  func textRemove(id: String) {
    let index = models.firstIndex { $0.id == id }
    guard let index = index else {
      return
    }
    models.remove(at: index)
    output?.didReceiveText(models: models)
  }
  
  func removeAllText() {
    models = []
    output?.didReceiveText(models: models)
  }
}

// MARK: - Appearance

private extension ListAddItemsScreenInteractor {
  struct Appearance {}
}
