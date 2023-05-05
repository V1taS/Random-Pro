//
//  RockPaperScissorsScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct RockPaperScissorsScreenModel {
  
  /// Общий результат
  let resultTitle: String
  
  /// Тип результата
  let resultType: ResultType
  
  /// Левая сторона
  let leftSide: HandsModel
  
  /// Правая сторона
  let rightSide: HandsModel
  
  // MARK: - HandsModel
  
  struct HandsModel {
    
    /// Тип руки
    let handsType: HandsType
    
    /// Отображение счета
    let score: Int
  }
  
  // MARK: - HandsType
  
  enum ResultType {
    
    /// Победила левая сторона
    case winLeftSide
    
    /// Победила правая сторона
    case winRightSide
    
    /// Ничья
    case draw
    
    /// Начальный результат
    case initial
  }
  
  // MARK: - HandsType
  
  enum HandsType {
    
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
    case rock
    
    /// Бумага
    case paper
    
    /// Ножницы
    case scissors
  }
}

// MARK: - Extension

extension RockPaperScissorsScreenModel.HandsType {
  struct Appearance {
    let rockName = RandomStrings.Localizable.stone
    let paperName = RandomStrings.Localizable.paper
    let scissorsName = RandomStrings.Localizable.scissors
  }
}
