//
//  TeamsScreenPlayerModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Протокол игрока
protocol PlayerProtocol {
  
  /// Состояние игрока
  associatedtype PlayerState = PlayerStateProtocol
  
  /// Уникальный номер игрока
  var id: String { get }
  
  /// Имя игрока
  var name: String { get }
  
  /// Аватарка игрока
  var avatar: Data?  { get }
  
  /// Смайлик
  var emoji: String? { get }
  
  /// Состояние игрока
  var state: PlayerState { get }
}

/// Протокол состояния игрока
protocol PlayerStateProtocol {
  
  /// Стандартное состояние
  static var random: Self { get }
  
  /// Не играет
  static var doesNotPlay: Self { get }
  
  /// Явно в команду номер 1
  static var teamOne: Self { get }
  
  /// Явно в команду номер 2
  static var teamTwo: Self { get }
  
  /// Явно в команду номер 3
  static var teamThree: Self { get }
  
  /// Явно в команду номер 4
  static var teamFour: Self { get }
  
  /// Явно в команду номер 5
  static var teamFive: Self { get }
  
  /// Явно в команду номер 6
  static var teamSix: Self { get }
  
  /// Описание каждого состояния
  var localizedName: String { get }
}

// MARK: - Player

/// Модель игрока
struct TeamsScreenPlayerModel: PlayerProtocol, UserDefaultsCodable {
  
  /// Уникальный номер игрока
  var id: String
  
  /// Имя игрока
  let name: String
  
  /// Аватарка игрока
  let avatar: Data?
  
  /// Смайлик
  let emoji: String?
  
  /// Состояние игрока
  let state: PlayerState
  
  // MARK: - PlayerState

  /// Состояние игрока
  enum PlayerState: PlayerStateProtocol, UserDefaultsCodable {
    
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
    let randomTitle = NSLocalizedString("Рандом", comment: "")
    let doesNotPlayTitle = NSLocalizedString("Не играет", comment: "")
    let teamTitle = NSLocalizedString("Команда", comment: "")
  }
}
