//
//  LetterScreenContent.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

enum LetterScreenContent {
  
  /// Русский контент
  case rus
  
  /// Английский контент
  case eng
}

struct LetterScreenModel: Equatable & Encodable & Decodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Без повторений
  let isEnabledWithoutRepetition: Bool
}
