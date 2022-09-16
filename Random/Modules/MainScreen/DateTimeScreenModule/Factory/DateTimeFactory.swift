//
//  DateTimeFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol DateTimeFactoryOutput: AnyObject {
  
  /// Список результатов был перевернут
  ///  - Parameter model: Модель
  func didReverseListResult(model: DateTimeScreenModel)
}

protocol DateTimeFactoryInput: AnyObject {
  
  /// Переворачивает список результатов
  ///  - Parameter model: Модель
  func reverseListResultFrom(model: DateTimeScreenModel)
}

final class DateTimeFactory: DateTimeFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: DateTimeFactoryOutput?
  
  // MARK: - Internal func
  
  func reverseListResultFrom(model: DateTimeScreenModel) {
    let newModel = DateTimeScreenModel(
      result: model.result,
      listResult: model.listResult.reversed()
    )
    output?.didReverseListResult(model: newModel)
  }
}
