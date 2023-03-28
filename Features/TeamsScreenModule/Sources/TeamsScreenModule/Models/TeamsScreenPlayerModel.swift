//
//  TeamsScreenPlayerModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import RandomUIKit
import UIKit

// MARK: - Player

/// Модель игрока
public struct TeamsScreenPlayerModel: Codable {
  
  /// Уникальный номер игрока
  public var id: String
  
  /// Имя игрока
  public let name: String
  
  /// Аватарка игрока
  public let avatar: String
  
  /// Смайлик
  public let emoji: String?
  
  /// Состояние игрока
  public let state: PlayerState
  
  /// Стиль карточки
  public let style: PlayerCardSelectionScreenModel.StyleCard
  
  // MARK: - PlayerState
  
  /// Состояние игрока
  public enum PlayerState: Codable {
    
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
    public var localizedName: String {
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
    let randomTitle = NSLocalizedString("Рандом", comment: "")
    let doesNotPlayTitle = NSLocalizedString("Не играет", comment: "")
    let teamTitle = NSLocalizedString("Команда", comment: "")
  }
}
