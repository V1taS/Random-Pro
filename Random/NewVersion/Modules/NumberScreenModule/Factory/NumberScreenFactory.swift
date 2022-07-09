//
//  NumberScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol NumberScreenFactoryOutput: AnyObject {
  
  /// Список результатов был перевернут
  ///  - Parameter listResult: массив результатов
  func didReverse(listResult: [String])
  
  /// Текст был очищен от лишних символов
  ///  - Parameter text: Результат генерации
  func didClearGeneration(text: String?)
}

protocol NumberScreenFactoryInput: AnyObject {
  
  /// Очистить текст от лишних символов
  ///  - Parameter text: Результат генерации
  func clearGeneration(text: String?)
  
  /// Переворачивает список результатов
  ///  - Parameter listResult: массив результатов
  func reverse(listResult: [String])
}

final class NumberScreenFactory: NumberScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: NumberScreenFactoryOutput?
  
  func reverse(listResult: [String]) {
    output?.didReverse(listResult: listResult.reversed())
  }
  
  func clearGeneration(text: String?) {
    guard let text = text else {
      return
    }

    let clearText = text.replacingOccurrences(of: Appearance().withoutSpaces, with: "")
    guard let number = Int(clearText) else {
      return
    }
    output?.didClearGeneration(text: "\(number)")
  }
}

// MARK: - Appearance

private extension NumberScreenFactory {
  struct Appearance {
    let withoutSpaces = " "
  }
}
