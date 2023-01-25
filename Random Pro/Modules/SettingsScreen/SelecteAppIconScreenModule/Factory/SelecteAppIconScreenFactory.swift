//
//  SelecteAppIconScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol SelecteAppIconScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации для таблички
  func didReceive(models: [SelecteAppIconScreenType])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol SelecteAppIconScreenFactoryInput {
  
  /// Создаем модельку для таблички
  func createListModel()
}

/// Фабрика
final class SelecteAppIconScreenFactory: SelecteAppIconScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModel() {
    var tableViewModels: [SelecteAppIconScreenType] = []
    tableViewModels.append(contentsOf: self.configureScreenType())
    
    output?.didReceive(models: tableViewModels)
  }
}

// MARK: -

private extension SelecteAppIconScreenFactory {
  func configureScreenType() -> [SelecteAppIconScreenType] {
    var tableViewModels: [SelecteAppIconScreenType] = []
    SelecteAppIconType.allCases.forEach {
      tableViewModels.append(.insets(4))
      tableViewModels.append(.divider)
      tableViewModels.append(.insets(4))
      tableViewModels.append(.largeImageAndLabelWithCheakmark(imageName: $0.imageName,
                                                              title: $0.title,
                                                              isSetCheakmark: false,
                                                              isSetLocked: true,
                                                              iconType: $0))
      tableViewModels.append(.insets(4))
    }
    return tableViewModels
  }
}
