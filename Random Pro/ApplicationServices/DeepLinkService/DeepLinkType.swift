//
//  DeepLinkType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

enum DeepLinkType: String, CaseIterable, UserDefaultsCodable {
  
  /// Имя хоста
  static var host: String {
    return "random://"
  }
  
  // MARK: - Screens
  
  /// Экран настроек
  case settingsScreen = "settings_screen"
  
  /// Экран генерации цветов
  case colorsScreen = "colors_screen"
  
  /// Экран Команды
  case teamsScreen = "teams_screen"
  
  /// Экран Да или нет
  case yesOrNoScreen = "yer_or_not_screen"
  
  /// Экран Буквы
  case characterScreen = "character_screen"
  
  /// Экран Списка
  case listScreen = "list_screen"
  
  /// Экран Монетки
  case coinScreen = "coin_screen"
  
  /// Экран Кубиков
  case cubeScreen = "cube_screen"
  
  /// Экран Даты и времени
  case dateAndTimeScreen = "date_and_time_screen"
  
  /// Экран Лотереи
  case lotteryScreen = "lottery_screen"
  
  /// Экран Контактов
  case contactScreen = "contact_screen"
  
  /// Экран Паролей
  case passwordScreen = "password_screen"
  
  /// Экран Чисел
  case numberScreen = "number_screen"
  
  /// Экран Бутылочка
  case bottleScreen = "bottle_screen"
  
  /// Экран Камень ножницы бумага
  case rockPaperScissorsScreen = "rock_paper_scissors_screen"

  case raffleScreen = "raffle_screen"
  
  // MARK: - Other
  
  /// Обновить приложением
  case updateApp = "update_app"
}
