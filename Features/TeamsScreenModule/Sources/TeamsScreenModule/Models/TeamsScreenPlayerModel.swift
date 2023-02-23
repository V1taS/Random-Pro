//
//  TeamsScreenPlayerModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import RandomUIKit
import ApplicationInterface
import UIKit

// MARK: - Player

/// Модель игрока
struct TeamsScreenPlayerModel: Codable, TeamsScreenPlayerModelProtocol {
  
  /// Уникальный номер игрока
  var id: String
  
  /// Имя игрока
  let name: String
  
  /// Аватарка игрока
  let avatar: String
  
  /// Смайлик
  let emoji: String?
  
  /// Состояние игрока
  let state: TeamsScreenPlayerStateProtocol
  
  /// Стиль карточки
  let style: TeamsScreenPlayerStyleCardProtocol
  
  // MARK: - Initialization
  
  init(id: String,
       name: String,
       avatar: String,
       emoji: String?,
       state: PlayerState,
       style: StyleCard) {
    self.id = id
    self.name = name
    self.avatar = avatar
    self.emoji = emoji
    self.state = state
    self.style = style
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    avatar = try container.decode(String.self, forKey: .avatar)
    emoji = try container.decode(String.self, forKey: .emoji)
    state = try container.decode(PlayerState.self, forKey: .state)
    style = try container.decode(StyleCard.self, forKey: .style)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(avatar, forKey: .avatar)
    try container.encode(emoji, forKey: .emoji)
    try container.encode(state as? PlayerState, forKey: .state)
    try container.encode(style as? StyleCard, forKey: .style)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case avatar
    case emoji
    case state
    case style
  }
  
  // MARK: - PlayerState

  /// Состояние игрока
  enum PlayerState: Codable, TeamsScreenPlayerStateProtocol {
        
    /// Состояние по умолчанию
    case random
    
    /// Не играет
    case doesNotPlay
    
    /// Принудительно в команду один
    case teamOne
    
    /// Принудительно в команду два
    case teamTwo
    
    /// Принудительно в команду три
    case teamThree
    
    /// Принудительно в команду четыре
    case teamFour
    
    /// Принудительно в команду пять
    case teamFive
    
    /// Принудительно в команду шесть
    case teamSix
    
    /// Описание каждого состояния
    var localizedName: String {
      let appearance = Appearance()
      switch self {
      case .random:
        return appearance.randomTitle
      case .doesNotPlay:
        return appearance.doesNotPlayTitle
      case .teamOne:
        return appearance.teamTitle + " - 1"
      case .teamTwo:
        return appearance.teamTitle + " - 2"
      case .teamThree:
        return appearance.teamTitle + " - 3"
      case .teamFour:
        return appearance.teamTitle + " - 4"
      case .teamFive:
        return appearance.teamTitle + " - 5"
      case .teamSix:
        return appearance.teamTitle + " - 6"
      }
    }
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

// MARK: - Appearance

private extension TeamsScreenPlayerModel {
  struct Appearance {
    let randomTitle = NSLocalizedString("Рандом", comment: "")
    let doesNotPlayTitle = NSLocalizedString("Не играет", comment: "")
    let teamTitle = NSLocalizedString("Команда", comment: "")
  }
}
