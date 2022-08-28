//
//  CoinScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CoinScreenFactoryOutput: AnyObject {
  
  /// Список результатов был перевернут
  ///  - Parameter model: Модель
  func didReverseListResult(model: CoinScreenModel)
}

protocol CoinScreenFactoryInput: AnyObject {
  
  /// Переворачивает список результатов
  ///  - Parameter model: Модель
  func reverseListResultFrom(model: CoinScreenModel)
}

final class CoinScreenFactory: CoinScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func reverseListResultFrom(model: CoinScreenModel) {
    let newModel = CoinScreenModel(
      result: model.result,
      сoinType: model.сoinType,
      listResult: model.listResult.reversed()
    )
    output?.didReverseListResult(model: newModel)
  }
}
