//
//  TeamsScreenModelProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - TeamsScreenModelProtocol

public protocol TeamsScreenModelProtocol {
  
  /// Выбранная команда (1-6)
  var selectedTeam: Int { get }
  
  /// Все игроки
  var allPlayers: [TeamsScreenPlayerModelProtocol]  { get }
  
  /// Список команд
  var teams: [TeamsScreenTeamModelProtocol]  { get }
}

// MARK: - TeamsScreenTeamModelProtocol

public protocol TeamsScreenTeamModelProtocol {
  
  /// Название команды
  var name: String { get }
  
  /// Список игроков
  var players: [TeamsScreenPlayerModelProtocol] { get }
}

// MARK: - TeamsScreenModelProtocol

public protocol TeamsScreenPlayerModelProtocol {
  
  /// Уникальный номер игрока
  var id: String { get }
  
  /// Имя игрока
  var name: String { get }
  
  /// Аватарка игрока
  var avatar: String { get }
  
  /// Смайлик
  var emoji: String? { get }
  
  /// Состояние игрока
  var state: TeamsScreenPlayerStateProtocol { get }
  
  /// Стиль карточки
  var style: TeamsScreenPlayerStyleCardProtocol { get }
}

// MARK: - TeamsScreenPlayerStyleCardProtocol

public protocol TeamsScreenPlayerStyleCardProtocol {
  
  /// Стиль по умолчанию
  static var defaultStyle: Self { get }
  
  /// Стиль темно-зеленый
  static var darkGreen: Self { get }
  
  /// Стиль темно-синий
  static var darkBlue: Self { get }
  
  /// Стиль темно-оранжевый
  static var darkOrange: Self { get }
  
  /// Стиль темно-красный
  static var darkRed: Self { get }
  
  /// Стиль темно-фиолетовый
  static var darkPurple: Self { get }
  
  /// Стиль темно-розовый
  static var darkPink: Self { get }
  
  /// Стиль темно-желтый
  static var darkYellow: Self { get }
}

// MARK: - TeamsScreenPlayerStateProtocol

public protocol TeamsScreenPlayerStateProtocol {
  
  /// Описание каждого состояния
  var localizedName: String { get }
  
  /// Состояние по умолчанию
  static var random: Self { get }
  
  /// Не играет
  static var doesNotPlay: Self { get }
  
  /// Принудительно в команду один
  static var teamOne: Self { get }
  
  /// Принудительно в команду два
  static var teamTwo: Self { get }
  
  /// Принудительно в команду три
  static var teamThree: Self { get }
  
  /// Принудительно в команду четыре
  static var teamFour: Self { get }
  
  /// Принудительно в команду пять
  static var teamFive: Self { get }
  
  /// Принудительно в команду шесть
  static var teamSix: Self { get }
}

