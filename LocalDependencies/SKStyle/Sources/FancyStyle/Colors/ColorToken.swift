//
//  ColorToken.swift
//  
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit

/// Список цветов
public enum ColorToken: CaseIterable {
  
  /// Заголовок цвета
  public var title: String {
    switch self {
    case .primaryGray:
      return "Primary Gray"
    case .secondaryGray:
      return "Secondary Gray"
    case .lightGray:
      return "Light Gray"
    case .tertiaryGray:
      return "Tertiary Gray"
    case .primaryGreen:
      return "Primary Green"
    case .secondaryGreen:
      return "Secondary Green"
    case .tertiaryGreen:
      return "Tertiary Green"
    case .primaryBlue:
      return "Primary Blue"
    case .secondaryBlue:
      return "Secondary Blue"
    case .tertiaryBlue:
      return "Tertiary Blue"
    case .primaryRed:
      return "Primary Red"
    case .primaryPink:
      return "Primary Pink"
    case .primaryOrange:
      return "Primary Orange"
    case .primaryYellow:
      return "Primary Yellow"
    case .primaryPurple:
      return "Primary Purple"
    case .primaryWhite:
      return "Primary White"
    case .secondaryWhite:
      return "Secondary White"
    case .primaryBlack:
      return "Primary Black"
    case .darkApple:
      return "Dark Apple"
    }
  }
  
  /// Hex цвета
  public var hexString: String {
    switch self {
    case .primaryGray:
      return "434A65"
    case .secondaryGray:
      return "8D91AA"
    case .lightGray:
      return "908F93"
    case .tertiaryGray:
      return "F3F3F6"
    case .primaryGreen:
      return "03ACB1"
    case .secondaryGreen:
      return "02CBAB"
    case .tertiaryGreen:
      return "EBF6F0"
    case .primaryBlue:
      return "007AFF"
    case .secondaryBlue:
      return "2EABDC"
    case .tertiaryBlue:
      return "6994F2"
    case .primaryRed:
      return "FF473A"
    case .primaryPink:
      return "E87AA4"
    case .primaryOrange:
      return "FB9405"
    case .primaryYellow:
      return "F4D100"
    case .primaryPurple:
      return "B171E1"
    case .primaryWhite:
      return "FFFFFF"
    case .secondaryWhite:
      return "F6F6F8"
    case .primaryBlack:
      return "000000"
    case .darkApple:
      return "292A2F"
    }
  }
  
  /// Темно-серый цвет
  case primaryGray
  
  /// Cерый цвет
  case secondaryGray
  
  /// Светло-серый цвет
  case lightGray
  
  /// Очень светло-серый цвет
  case tertiaryGray
  
  /// Темно-зеленый цвет
  case primaryGreen
  
  /// Светло-зеленый цвет
  case secondaryGreen
  
  /// Очень светло-зеленый цвет
  case tertiaryGreen
  
  /// Основной синий цвет
  case primaryBlue
  
  /// Светло-синий цвет
  case secondaryBlue
  
  /// Светло-синий цвет
  case tertiaryBlue
  
  /// Ярко-красный цвет
  case primaryRed
  
  /// Основной розовый цвет
  case primaryPink
  
  /// Основной оранжевый
  case primaryOrange
  
  /// Основной Желтый
  case primaryYellow
  
  /// Основной фиолетовый
  case primaryPurple
  
  /// Светло-белый цвет
  case primaryWhite
  
  /// Темно-белый цвет
  case secondaryWhite
  
  /// Основной черный цвет
  case primaryBlack
  
  /// Темный цвет Apple
  case darkApple
}
