//
//  LotteryScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LotteryScreenFactoryOutput: AnyObject {
  
  /// Список результатов был перевернут
  ///  - Parameter model: Модель
  func didReverseListResult(model: LotteryScreenModel)
}

protocol LotteryScreenFactoryInput: AnyObject {
  
  /// Переворачивает список результатов
  ///  - Parameter model: Модель
  func reverseListResultFrom(model: LotteryScreenModel)
}

final class LotteryScreenFactory: LotteryScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: LotteryScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func reverseListResultFrom(model: LotteryScreenModel) {
    let newModel = LotteryScreenModel(
      rangeStartValue: model.rangeStartValue,
      rangeEndValue: model.rangeEndValue,
      amountValue: model.amountValue,
      result: model.result,
      listResult: model.listResult.reversed()
    )
    output?.didReverseListResult(model: newModel)
  }
}
