//
//  CoinScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol CoinScreenFactoryOutput: AnyObject {
  
  /// Возвращает перевернутый список результатов
  /// - Parameter listResult: массив результатов
  func didRevarsed(listResult: [String])
}

protocol CoinScreenFactoryInput: AnyObject {
  
  /// Перевернуть список результатов
  /// - Parameter listResult: массов результатов
  func revers(listResult: [String])
}

final class CoinScreenFactory: CoinScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: CoinScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func revers(listResult: [String]) {
    output?.didRevarsed(listResult: listResult.reversed())
  }
}
