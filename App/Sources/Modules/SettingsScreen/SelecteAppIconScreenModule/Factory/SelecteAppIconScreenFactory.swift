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
  func createListModelWith(selectImageType: SelecteAppIconType, and isPremium: Bool)
}

/// Фабрика
final class SelecteAppIconScreenFactory: SelecteAppIconScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SelecteAppIconScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelWith(selectImageType: SelecteAppIconType, and isPremium: Bool) {
    configureScreenType(selectImageType, and: isPremium) { [weak self] models in
      self?.output?.didReceive(models: models)
    }
  }
}

// MARK: -

private extension SelecteAppIconScreenFactory {
  func configureScreenType(_ selectImageType: SelecteAppIconType,
                           and isPremium: Bool,
                           completion: ([SelecteAppIconScreenType]) -> Void) {
    let allImage = SelecteAppIconType.allCases.filter { $0 != .defaultIcon }
    var tableViewModels: [SelecteAppIconScreenType] = []
    let defaultImage = SelecteAppIconType.defaultIcon
    
    tableViewModels.append(.insets(4))
    tableViewModels.append(.divider)
    tableViewModels.append(.insets(4))
    tableViewModels.append(.largeImageAndLabelWithCheakmark(
      imageName: defaultImage.imageName,
      title: defaultImage.title,
      isSetCheakmark: selectImageType == .defaultIcon,
      isSetLocked: false,
      iconType: defaultImage
    ))
    tableViewModels.append(.insets(4))
    
    allImage.forEach {
      tableViewModels.append(.insets(4))
      tableViewModels.append(.divider)
      tableViewModels.append(.insets(4))
      tableViewModels.append(.largeImageAndLabelWithCheakmark(
        imageName: $0.imageName,
        title: $0.title,
        isSetCheakmark: selectImageType == $0,
        isSetLocked: !isPremium,
        iconType: $0
      ))
      tableViewModels.append(.insets(4))
    }
    completion(tableViewModels)
  }
}
