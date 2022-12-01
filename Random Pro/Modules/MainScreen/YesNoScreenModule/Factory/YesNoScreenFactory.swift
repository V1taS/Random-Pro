//
//  YesNoScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol YesNoScreenFactoryOutput: AnyObject {
  
  /// Список результатов был перевернут
  ///  - Parameter listResult: массив результатов
  func didReverse(listResult: [String])
}

protocol YesNoScreenFactoryInput: AnyObject {
  
  /// Переворачивает список результатов
  ///  - Parameter listResult: массив результатов
  func reverse(listResult: [String])
}

final class YesNoScreenFactory: YesNoScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: YesNoScreenFactoryOutput?
  
  // MARK: - Initarnal func
  
  func reverse(listResult: [String]) {
    output?.didReverse(listResult: listResult.reversed())
  }
}
