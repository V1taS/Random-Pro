//
//  TeamsScreenPlayerModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import FancyUIKit
import FancyStyle
import SKAbstractions

// MARK: - Player

/// Модель игрока
struct TeamsScreenPlayerModel: UserDefaultsCodable {
  
  /// Уникальный номер игрока
  var id: String
  
  /// Имя игрока
  let name: String
  
  /// Аватарка игрока
  let avatar: String
  
  /// Смайлик
  let emoji: String?
  
  /// Состояние игрока
  let state: PlayerState
  
  /// Стиль карточки
  let style: PlayerView.StyleCard
  
  // MARK: - PlayerState

  /// Состояние игрока
  enum PlayerState: UserDefaultsCodable {
    
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
}

// MARK: - Appearance

private extension TeamsScreenPlayerModel {
  struct Appearance {
    let randomTitle = RandomStrings.Localizable.random
    let doesNotPlayTitle = RandomStrings.Localizable.notPlaying
    let teamTitle = RandomStrings.Localizable.team
  }
}
