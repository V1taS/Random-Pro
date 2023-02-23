//
//  MainScreenModelProtocol.swift
//  ApplicationModels
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - MainScreenModelProtocol

public protocol MainScreenModelProtocol {
  
  /// Темная тема включена
  var isDarkMode: Bool? { get }
  
  /// Доступность премиума
  var isPremium: Bool { get }
  
  /// Все секции приложения
  var allSections: [MainScreenSectionProtocol] { get }
}

// MARK: - MainScreenSectionProtocol

public protocol MainScreenSectionProtocol {
  
  /// Тип секции
  var type: MainScreenSectionTypeProtocol { get }
  
  /// Имя изображения секции
  var imageSectionSystemName: String { get }
  
  /// Название  секции
  var titleSection: String { get }
  
  /// Секция включена
  var isEnabled: Bool { get }
  
  /// Секция скрыта
  var isHidden: Bool { get }
  
  /// Тип лайбла
  var advLabel: MainScreenADVLabelProtocol { get }
}

// MARK: - MainScreenADVLabelProtocol

public protocol MainScreenADVLabelProtocol {
  
  var title: String { get }
  
  /// Лайбл: `ХИТ`
  static var hit: Self { get }
  
  /// Лайбл: `НОВОЕ`
  static var new: Self { get }
  
  /// Лайбл: `ПРЕМИУМ`
  static var premium: Self { get }
  
  /// Лайбл: `Пусто`
  static var none: Self { get }
}

// MARK: - MainScreenSectionTypeProtocol

public protocol MainScreenSectionTypeProtocol {
  
  /// Название секции
  var titleSection: String { get }
  
  /// Иконка секции
  var imageSectionSystemName: String { get }
  
  /// Описание когда нет премиум доступа
  var descriptionForNoPremiumAccess: String { get }
  
  /// Раздел: `Команды`
  static var teams: Self { get }
  
  /// Раздел: `Число`
  static var number: Self { get }
  
  /// Раздел: `Да или Нет`
  static var yesOrNo: Self { get }
  
  /// Раздел: `Буква`
  static var letter: Self { get }
  
  /// Раздел: `Список`
  static var list: Self { get }
  
  /// Раздел: `Монета`
  static var coin: Self { get }
  
  /// Раздел: `Кубики`
  static var cube: Self { get }
  
  /// Раздел: `Дата и Время`
  static var dateAndTime: Self { get }
  
  /// Раздел: `Лотерея`
  static var lottery: Self { get }
  
  /// Раздел: `Контакты`
  static var contact: Self { get }
  
  /// Раздел: `Пароли`
  static var password: Self { get }
  
  /// Раздел: `Цвета`
  static var colors: Self { get }
  
  /// Раздел: `Бутылочка`
  static var bottle: Self { get }
  
  /// Раздел `Камень, ножницы, бумага`
  static var rockPaperScissors: Self { get }
  
  /// Раздел `Фильтры изображений`
  static var imageFilters: Self { get }
  
  /// Раздел `Фильмы`
  static var films: Self { get }
}
