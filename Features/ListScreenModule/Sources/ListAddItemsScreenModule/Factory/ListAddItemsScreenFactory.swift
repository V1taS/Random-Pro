//
//  ListAddItemsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ListAddItemsScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации для таблички
  func didReceive(models: [ListAddItemsScreenModel])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol ListAddItemsScreenFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameter models: Список моделек с текстом
  func createListModelFrom(models: [ListScreenModel.TextModel])
}

/// Фабрика
final class ListAddItemsScreenFactory: ListAddItemsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ListAddItemsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelFrom(models: [ListScreenModel.TextModel]) {
    output?.didReceive(models: createListFrom(models: models))
  }
}

// MARK: - Private

private extension ListAddItemsScreenFactory {
  func createListFrom(models: [ListScreenModel.TextModel]) -> [ListAddItemsScreenModel] {
    let appearance = Appearance()
    var tableViewModels: [ListAddItemsScreenModel] = []
    var textCount: Int = .zero
    
    tableViewModels.append(.insets(appearance.middleInset))
    tableViewModels.append(.textField)
    tableViewModels.append(.insets(appearance.minimumInset))
    
    if !models.isEmpty {
      tableViewModels.append(.doubleTitle(textCount: models.count,
                                          textForGeneratedCount: nil))
      tableViewModels.append(.divider)
    }
    
    models.reversed().forEach {
      textCount += appearance.increase
      tableViewModels.append(.text(ListScreenModel.TextModel(
        id: $0.id,
        text: $0.text
      )))
      
      if textCount != models.count {
        tableViewModels.append(.divider)
      }
    }
    
    return tableViewModels
  }
}

// MARK: - Appearance

private extension ListAddItemsScreenFactory {
  struct Appearance {
    let minimumInset: Double = 8
    let middleInset: Double = 16
    let increase = 1
  }
}
