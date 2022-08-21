//
//  PlayerStateProtocol.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 21.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

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
