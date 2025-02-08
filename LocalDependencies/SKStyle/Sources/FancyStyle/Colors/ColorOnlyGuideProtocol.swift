//
//  ColorOnlyGuideProtocol.swift
//  FancyStyle
//
//  Created by Vitalii Sosin on 09.09.2023.
//

import Foundation

protocol ColorOnlyGuideProtocol {
  associatedtype ColorType
  
  /// Темно-серый цвет
  var primaryGray: ColorType { get }
  
  /// Серый цвет
  var secondaryGray: ColorType { get }
  
  /// Светло-серый цвет
  var lightGray: ColorType { get }
  
  /// Очень светло-серый цвет
  var tertiaryGray: ColorType { get }
  
  /// Темно-зеленый цвет
  var primaryGreen: ColorType { get }
  
  /// Светло-зеленый цвет
  var secondaryGreen: ColorType { get }
  
  /// Очень светло-зеленый цвет
  var tertiaryGreen: ColorType { get }
  
  /// Основной синий цвет
  var primaryBlue: ColorType { get }
  
  /// Светло-синий цвет
  var secondaryBlue: ColorType { get }
  
  /// Светло-синий цвет
  var tertiaryBlue: ColorType { get }
  
  /// Ярко-красный цвет
  var primaryRed: ColorType { get }
  
  /// Основной розовый цвет
  var primaryPink: ColorType { get }
  
  /// Основной оранжевый цвет
  var primaryOrange: ColorType { get }
  
  /// Основной желтый цвет
  var primaryYellow: ColorType { get }
  
  /// Основной фиолетовый цвет
  var primaryPurple: ColorType { get }
  
  /// Светло-белый цвет
  var primaryWhite: ColorType { get }
  
  /// Темно-белый цвет
  var secondaryWhite: ColorType { get }
  
  /// Основной черный цвет
  var primaryBlack: ColorType { get }
  
  /// Темный цвет Apple
  var darkApple: ColorType { get }
}
