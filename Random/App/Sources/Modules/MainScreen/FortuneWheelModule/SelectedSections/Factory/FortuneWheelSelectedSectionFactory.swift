//
//  FortuneWheelSelectedSectionFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol FortuneWheelSelectedSectionFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol FortuneWheelSelectedSectionFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameter model: Модель с данными
  func createListModel(_ model: FortuneWheelModel) -> [FortuneWheelSelectedSectionTableViewType]
}

/// Фабрика
final class FortuneWheelSelectedSectionFactory: FortuneWheelSelectedSectionFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelSelectedSectionFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModel(_ model: FortuneWheelModel) -> [FortuneWheelSelectedSectionTableViewType] {
    var tableViewModels: [FortuneWheelSelectedSectionTableViewType] = []
    tableViewModels.append(.headerText("Разделы для генерации"))
    tableViewModels.append(.insets(4))
    
    model.sections.forEach { section in
      tableViewModels.append(.wheelSection(section))
      tableViewModels.append(.insets(8))
    }
    
    tableViewModels.append(.insets(16))
    tableViewModels.append(.createNewSectionButton)
    return tableViewModels
  }
}

// MARK: - Appearance

private extension FortuneWheelSelectedSectionFactory {
  struct Appearance {}
}
