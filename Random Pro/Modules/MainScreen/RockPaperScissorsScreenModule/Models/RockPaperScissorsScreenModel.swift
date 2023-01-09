//
//  RockPaperScissorsScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import UIKit

struct RockPaperScissorsScreenModel {
  
  /// Левая сторона экрана
  let leftSideScreen: HandsType
  
  /// Отображение счета слева
  let leftSideScore: Int
  
  /// Правая сторона экрана
  let rightSideScreen: HandsType
  
  /// Отображение счета справа
  let rightSideScore: Int
  
  /// Общий результат
  let result: String
  
  enum HandsType: Equatable {
    
    ///  Названия для обозначения картинок
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

    /// Камень
    case rock(Data?)
    
    /// Бумага
    case paper(Data?)
    
    /// Ножницы
    case scissors(Data?)
  }
}

// MARK: - Extension

extension RockPaperScissorsScreenModel.HandsType {
  struct Appearance {
    let rockName = NSLocalizedString("Камень", comment: "")
    let paperName = NSLocalizedString("Бумага", comment: "")
    let scissorsName = NSLocalizedString("Ножницы", comment: "")
  }
}
