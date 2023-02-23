//
//  PlayerCardSelectionScreenModel.swift
//  TeamsScreenModule
//
//  Created by Vitalii Sosin on 26.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface
import UIKit

// MARK: - PlayerCardSelectionScreenModel

struct PlayerCardSelectionScreenModel: Codable, PlayerCardSelectionScreenModelProtocol {
  
  /// Уникальный номер игрока
  var id: String
  
  /// Имя игрока
  let name: String
  
  /// Аватарка игрока
  let avatar: String
  
  /// Стиль карточки
  let style: TeamsScreenPlayerStyleCardProtocol
  
  /// Выбрана карточка игрока
  let playerCardSelection: Bool
  
  /// Премиум режим
  let isPremium: Bool
  
  // MARK: - Initialization
  
  init(id: String,
       name: String,
       avatar: String,
       style: TeamsScreenPlayerStyleCardProtocol,
       playerCardSelection: Bool,
       isPremium: Bool) {
    self.id = id
    self.name = name
    self.avatar = avatar
    self.style = style
    self.playerCardSelection = playerCardSelection
    self.isPremium = isPremium
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    avatar = try container.decode(String.self, forKey: .avatar)
    style = try container.decode(StyleCard.self, forKey: .style)
    playerCardSelection = try container.decode(Bool.self, forKey: .playerCardSelection)
    isPremium = try container.decode(Bool.self, forKey: .isPremium)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(avatar, forKey: .avatar)
    try container.encode(style as? StyleCard, forKey: .style)
    try container.encode(playerCardSelection, forKey: .playerCardSelection)
    try container.encode(isPremium, forKey: .isPremium)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case avatar
    case style
    case playerCardSelection
    case isPremium
  }
  
  // MARK: - StyleCard
  
  /// Стиль карточки
  public enum StyleCard: Codable, TeamsScreenPlayerStyleCardProtocol {
    
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

// MARK: - toCodable

extension [PlayerCardSelectionScreenModelProtocol] {
  func toCodable() -> [PlayerCardSelectionScreenModel]? {
    let models: [PlayerCardSelectionScreenModel] = self.map {
      return PlayerCardSelectionScreenModel(id: $0.id,
                                            name: $0.name,
                                            avatar: $0.avatar,
                                            style: ($0.style as? PlayerCardSelectionScreenModel.StyleCard) ?? .defaultStyle,
                                            playerCardSelection: $0.playerCardSelection,
                                            isPremium: $0.isPremium)
    }
    return models
  }
}
