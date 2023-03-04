//
//  PlayerCardSelectionScreenModelProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - PlayerCardSelectionScreenModelProtocol

public protocol PlayerCardSelectionScreenModelProtocol {
  
  /// Уникальный номер игрока
  var id: String { get }
  
  /// Имя игрока
  var name: String { get }
  
  /// Аватарка игрока
  var avatar: String { get }
  
  /// Стиль карточки
  var style: TeamsScreenPlayerStyleCardProtocol { get }
  
  /// Выбрана карточка игрока
  var playerCardSelection: Bool { get }
  
  /// Премиум режим
  var isPremium: Bool { get }
}

