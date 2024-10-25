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
  ///   - section: Секция
  func createListModel(_ section: FortuneWheelModel.Section?) -> [FortuneWheelEditSectionTableViewType]
}

/// Фабрика
final class FortuneWheelEditSectionFactory: FortuneWheelEditSectionFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelEditSectionFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModel(_ section: FortuneWheelModel.Section?) -> [FortuneWheelEditSectionTableViewType] {
    let appearance = Appearance()
    var tableViewModels: [FortuneWheelEditSectionTableViewType] = []
    
    tableViewModels.append(.headerText(appearance.headerSectionTitle))
    tableViewModels.append(.textfieldAddSection(section?.title, emoticon: Character(section?.icon ?? "😍")))
    
    tableViewModels.append(.insets(16))
    tableViewModels.append(.headerText(appearance.listObjectTitle))
    
    tableViewModels.append(.divider)
    
    if let objects = section?.objects {
      objects.forEach { section in
        tableViewModels.append(.wheelObject(section.text ?? ""))
        tableViewModels.append(.divider)
      }
    }

    tableViewModels.append(.insets(16))
    tableViewModels.append(.textfieldAddObjects)
    return tableViewModels
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionFactory {
  struct Appearance {
    let headerSectionTitle = RandomStrings.Localizable.sectionName
    let listObjectTitle = RandomStrings.Localizable.listOfElements
  }
}
