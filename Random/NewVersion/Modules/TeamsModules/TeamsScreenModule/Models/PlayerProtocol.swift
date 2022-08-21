//
//  PlayerProtocol.swift
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
