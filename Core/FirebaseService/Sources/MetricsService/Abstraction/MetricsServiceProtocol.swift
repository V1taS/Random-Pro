//
//  MetricsServiceProtocol.swift
//  MetricsService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - MetricsServiceProtocol

public protocol MetricsServiceProtocol {
  
  /// Отправляем стандартную метрику
  ///  - Parameter event: Выбираем метрику
  func track(event: MetricsSectionsProtocol)
  
  /// Отправляем метрику и дополнительную информацию в словаре `[String : String]`
  /// - Parameters:
  ///  - event: Выбираем метрику
  ///  - properties: Словарик с дополнительной информацией `[String : String]`
  func track(event: MetricsSectionsProtocol, properties: [String: String])
}

import Foundation

// MARK: - MetricsSectionsProtocol

public protocol MetricsSectionsProtocol {
  
  /// Поделиться приложением
  static var shareApp: Self { get }
  
  /// Поделиться изображением
  static var shareImage: Self { get }
  
  /// Поделиться цветом
  static var shareColors: Self { get }
  
  /// Поделиться изображением из фильтров
  static var shareImageFilters: Self { get }
  
  /// Секция Фильмы
  static var filmScreen: Self { get }
  
  /// Секция Команды
  static var teamsScreen: Self { get }
  
  /// Секция Цифры
  static var numbersScreen: Self { get }
  
  /// Секция Да или нет
  static var yesOrNotScreen: Self { get }
  
  /// Секция Буква
  static var charactersScreen: Self { get }
  
  /// Секция Список
  static var listScreen: Self { get }
  
  /// Секция Монетка
  static var coinScreen: Self { get }
  
  /// Секция Кубики
  static var cubeScreen: Self { get }
  
  /// Секция Дата и время
  static var dateAndTimeScreen: Self { get }
  
  /// Секция Лотерея
  static var lotteryScreen: Self { get }
  
  /// Секция Контакты
  static var contactScreen: Self { get }
  
  /// Секция Пароли
  static var passwordScreen: Self { get }
  
  /// Секция Цвета
  static var colorsScreen: Self { get }
  
  /// Секция Бутылочка
  static var bottleScreen: Self { get }
  
  /// Секция Камень ножницы бумага
  static var rockPaperScissors: Self { get }
  
  /// Секция Фильтры изображений
  static var imageFilters: Self { get }
  
  /// Секция Главный экран настроек
  static var mainSettingsScreen: Self { get }
  
  /// Секция Настройка секций на главном экране
  static var customMainSections: Self { get }
  
  /// Нажата кнопка обратной связи
  static var feedBack: Self { get }
  
  /// Секция Выбрать иконку
  static var selecteAppIcon: Self { get }
  
  /// Переход по Deep links
  static var deepLinks: Self { get }
  
  /// Секция Премиум
  static var premiumScreen: Self { get }
  
  /// Секция Выбора карточки у игрока в разделе Команды
  static var premiumPlayerCardSelection: Self { get }
}

