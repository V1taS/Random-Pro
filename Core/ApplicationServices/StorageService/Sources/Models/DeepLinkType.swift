//
//  DeepLinkType.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

enum DeepLinkType: Codable, DeepLinkTypeProtocol {
  
  /// Имя хоста
  var host: String { "" }
  
  // MARK: - Screens
  
  /// Экран настроек
  case settingsScreen
  
  /// Экран генерации цветов
  case colorsScreen
  
  /// Экран Команды
  case teamsScreen
  
  /// Экран Да или нет
  case yesOrNoScreen
  
  /// Экран Буквы
  case characterScreen
  
  /// Экран Списка
  case listScreen
  
  /// Экран Монетки
  case coinScreen
  
  /// Экран Кубиков
  case cubeScreen
  
  /// Экран Даты и времени
  case dateAndTimeScreen
  
  /// Экран Лотереи
  case lotteryScreen
  
  /// Экран Контактов
  case contactScreen
  
  /// Экран Паролей
  case passwordScreen
  
  /// Экран Чисел
  case numberScreen
  
  /// Экран Бутылочка
  case bottleScreen
  
  /// Экран Камень ножницы бумага
  case rockPaperScissorsScreen
  
  /// Раздел `Фильтры изображений`
  case imageFilters
  
  /// Раздел `Фильмы`
  case filmsScreen
  
  // MARK: - Other
  
  /// Обновить приложением
  case updateApp
  
  /// Экран премиум раздела
  case premiumScreen
}

// MARK: - toCodable

extension DeepLinkTypeProtocol {
  func toCodable() -> DeepLinkType? {
    guard let deepLinkType = self as? DeepLinkType else {
      return nil
    }
    return deepLinkType
  }
}
