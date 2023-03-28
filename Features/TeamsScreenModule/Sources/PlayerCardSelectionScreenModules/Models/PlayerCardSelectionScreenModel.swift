//
//  PlayerCardSelectionScreenModel.swift
//  TeamsScreenModule
//
//  Created by Vitalii Sosin on 26.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PlayerCardSelectionScreenModel

public struct PlayerCardSelectionScreenModel: Codable {
  
  /// Уникальный номер игрока
  public var id: String
  
  /// Имя игрока
  public let name: String
  
  /// Аватарка игрока
  public let avatar: String
  
  /// Стиль карточки
  public let style: StyleCard
  
  /// Выбрана карточка игрока
  public let playerCardSelection: Bool
  
  /// Премиум режим
  public let isPremium: Bool
  
  // MARK: - StyleCard
  
  /// Стиль карточки
  public enum StyleCard: Codable {
    
    /// Стиль по умолчанию
    case defaultStyle
    
    /// Стиль темно-зеленый
    case darkGreen
    
    /// Стиль темно-синий
    case darkBlue
    
    /// Стиль темно-оранжевый
    case darkOrange
    
    /// Стиль темно-красный
    case darkRed
    
    /// Стиль темно-фиолетовый
    case darkPurple
    
    /// Стиль темно-розовый
    case darkPink
    
    /// Стиль темно-желтый
    case darkYellow
  }
}
