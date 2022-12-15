//
//  RockPaperScissorsScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

enum RockPaperScissorsScreenModel: CaseIterable {
  
  ///  Названия для обозначения смайлов
  var title: String {
    let appearance = Appearance()
    
    switch self {
    case .rock:
      return appearance.rockName
    case .paper:
      return appearance.paperName
    case .scissors:
      return appearance.scissorsName
    }
  }
  
  ///  Смайлики
  var emoji: String {
    let appearance = Appearance()
    
    switch self {
    case .rock:
      return appearance.rockEmoji
    case .paper:
      return appearance.paperEmoji
    case .scissors:
      return appearance.scissorsEmoji
    }
  }
  
  /// Камень
  case rock
  
  /// Бумага
  case paper
  
  /// Ножницы
  case scissors
}

extension RockPaperScissorsScreenModel {
  struct Appearance {
    let rockName = NSLocalizedString("Камень", comment: "")
    let rockEmoji = "✊🏼"
    let paperName = NSLocalizedString("Бумага", comment: "")
    let paperEmoji = "✋🏼"
    let scissorsName = NSLocalizedString("Ножницы", comment: "")
    let scissorsEmoji = "✌🏼"
  }
}
