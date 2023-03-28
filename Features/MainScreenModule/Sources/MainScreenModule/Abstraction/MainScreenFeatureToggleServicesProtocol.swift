//
//  FeatureToggleServicesProtocol.swift
//  MainScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - FeatureToggleServicesProtocol

public protocol MainScreenFeatureToggleServicesProtocol {
  
  /// Получить секции, которые надо скрыть из приложения
  func getSectionsIsHiddenFTForMain(completion: @escaping (MainScreenSectionsIsHiddenFTModelProtocol?) -> Void)
  
  /// Получить лайблы для ячеек на главном экране
  func getLabelsFeatureToggleForMain(completion: @escaping (MainScreenLabelsFeatureToggleModelProtocol?) -> Void)
  
  /// Получить премиум
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void)
  
  /// Получить возможность показывать баннер обнови приложение
  func getUpdateAppFeatureToggle(completion: @escaping (_ isUpdateAvailable: Bool) -> Void)
}

// MARK: - UpdateAppFeatureToggleModelProtocol

public protocol MainScreenUpdateAppFeatureToggleModelProtocol {
  
  /// Доступность баннера обновить приложение
  var isUpdateAvailable: Bool { get }
}

// MARK: - SectionsIsHiddenFTModelProtocol

public protocol MainScreenSectionsIsHiddenFTModelProtocol {
  
  /// Раздел: `Команды`
  var teams: Bool { get }
  
  /// Раздел: `Число`
  var number: Bool { get }
  
  /// Раздел: `Да или Нет`
  var yesOrNo: Bool { get }
  
  /// Раздел: `Буква`
  var letter: Bool { get }
  
  /// Раздел: `Список`
  var list: Bool { get }
  
  /// Раздел: `Монета`
  var coin: Bool { get }
  
  /// Раздел: `Кубики`
  var cube: Bool { get }
  
  /// Раздел: `Дата и Время`
  var dateAndTime: Bool { get }
  
  /// Раздел: `Лотерея`
  var lottery: Bool { get }
  
  /// Раздел: `Контакты`
  var contact: Bool { get }
  
  /// Раздел: `Пароли`
  var password: Bool { get }
  
  /// Раздел: `Цвета`
  var colors: Bool { get }
  
  /// Раздел: `Бутылочка`
  var bottle: Bool { get }
  
  /// Раздел `Камень, ножницы, бумага`
  var rockPaperScissors: Bool { get }
  
  /// Раздел `Фильтры изображений`
  var imageFilters: Bool { get }
  
  /// Раздел `Фильмы`
  var films: Bool { get }
}

// MARK: - PremiumFeatureToggleModelProtocol

public protocol MainScreenPremiumFeatureToggleModelProtocol {
  
  /// Уникальное ID устройства
  var id: String? { get }
  
  /// премиум включен
  var isPremium: Bool? { get }
}

// MARK: - LabelsFeatureToggleModelProtocol

public protocol MainScreenLabelsFeatureToggleModelProtocol {
  
  /// Раздел: `Команды`
  var teams: String { get }
  
  /// Раздел: `Число`
  var number: String { get }
  
  /// Раздел: `Да или Нет`
  var yesOrNo: String { get }
  
  /// Раздел: `Буква`
  var letter: String { get }
  
  /// Раздел: `Список`
  var list: String { get }
  
  /// Раздел: `Монета`
  var coin: String { get }
  
  /// Раздел: `Кубики`
  var cube: String { get }
  
  /// Раздел: `Дата и Время`
  var dateAndTime: String { get }
  
  /// Раздел: `Лотерея`
  var lottery: String { get }
  
  /// Раздел: `Контакты`
  var contact: String { get }
  
  /// Раздел: `Пароли`
  var password: String { get }
  
  /// Раздел: `Цвета`
  var colors: String { get }
  
  /// Раздел: `Бутылочка`
  var bottle: String { get }
  
  /// Раздел `Камень, ножницы, бумага`
  var rockPaperScissors: String { get }
  
  /// Раздел `Фильтры изображений`
  var imageFilters: String { get }
  
  /// Раздел `Фильмы`
  var films: String { get }
}
