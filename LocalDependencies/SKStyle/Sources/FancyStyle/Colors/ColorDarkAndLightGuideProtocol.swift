//
//  ColorDarkAndLightGuideProtocol.swift
//  FancyStyle
//
//  Created by Vitalii Sosin on 09.09.2023.
//

import Foundation

protocol ColorDarkAndLightGuideProtocol {
  associatedtype ColorType
  
  /// Темно-серый цвет
  var primaryGray: ColorType { get }
  
  /// Светло-серый цвет
  var secondaryGray: ColorType { get }
  
  /// Очень светло-зеленый цвет
  var tertiaryGreen: ColorType { get }
  
  /// Светло-белый цвет
  var primaryWhite: ColorType { get }
  
  /// Темно-белый цвет
  var secondaryWhite: ColorType { get }
  
  /// Основной черный цвет
  var primaryBlack: ColorType { get }
}
