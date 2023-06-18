//
//  FortuneWheelEditSectionFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol FortuneWheelEditSectionFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol FortuneWheelEditSectionFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameters:
  ///   - model: Модель с данными
  ///   - section: Текущая секция
  func createListModel(_ model: FortuneWheelModel,
                       _ section: FortuneWheelModel.Section?) -> [FortuneWheelEditSectionTableViewType]
}

/// Фабрика
final class FortuneWheelEditSectionFactory: FortuneWheelEditSectionFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelEditSectionFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModel(_ model: FortuneWheelModel,
                       _ section: FortuneWheelModel.Section?) -> [FortuneWheelEditSectionTableViewType] {
    var tableViewModels: [FortuneWheelEditSectionTableViewType] = []
    tableViewModels.append(.headerText("Название секции"))
    tableViewModels.append(.textfieldAddSection(section?.title))
    
    tableViewModels.append(.insets(16))
    tableViewModels.append(.headerText("Добавляем объекты"))
    tableViewModels.append(.textfieldAddObjects)
    
    tableViewModels.append(.insets(16))
    tableViewModels.append(.headerText("Список объектов"))
    tableViewModels.append(.insets(4))
    
    if let objects = section?.objects {
      objects.forEach { section in
        tableViewModels.append(.wheelObject(section))
        tableViewModels.append(.insets(8))
      }
    }
    return tableViewModels
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionFactory {
  struct Appearance {}
}
