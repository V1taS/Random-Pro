//
//  DeepLinkTypeProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - DeepLinkTypeProtocol

public protocol DeepLinkTypeProtocol {
  
  /// Имя хоста
  var host: String { get }
  
  // MARK: - Screens
  
  /// Экран настроек
  static var settingsScreen: Self { get }
  
  /// Экран генерации цветов
  static var colorsScreen: Self { get }
  
  /// Экран Команды
  static var teamsScreen: Self { get }
  
  /// Экран Да или нет
  static var yesOrNoScreen: Self { get }
  
  /// Экран Буквы
  static var characterScreen: Self { get }
  
  /// Экран Списка
  static var listScreen: Self { get }
  
  /// Экран Монетки
  static var coinScreen: Self { get }
  
  /// Экран Кубиков
  static var cubeScreen: Self { get }
  
  /// Экран Даты и времени
  static var dateAndTimeScreen: Self { get }
  
  /// Экран Лотереи
  static var lotteryScreen: Self { get }
  
  /// Экран Контактов
  static var contactScreen: Self { get }
  
  /// Экран Паролей
  static var passwordScreen: Self { get }
  
  /// Экран Чисел
  static var numberScreen: Self { get }
  
  /// Экран Бутылочка
  static var bottleScreen: Self { get }
  
  /// Экран Камень ножницы бумага
  static var rockPaperScissorsScreen: Self { get }
  
  /// Раздел `Фильтры изображений`
  static var imageFilters: Self { get }
  
  /// Раздел `Фильмы`
  static var filmsScreen: Self { get }
  
  // MARK: - Other
  
  /// Обновить приложением
  static var updateApp: Self { get }
  
  /// Экран премиум раздела
  static var premiumScreen: Self { get }
}

