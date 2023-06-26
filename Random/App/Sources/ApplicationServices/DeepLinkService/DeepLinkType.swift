//
//  DeepLinkType.swift
//  Random
//
//  Created by Vitalii Sosin on 26.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum DeepLinkType: CaseIterable, UserDefaultsCodable {
  
  /// Диплинки на открытие экрана
  var deepLinkEndPoint: String {
    switch self {
    case .teams:
      return "teams_screen"
    case .number:
      return "number_screen"
    case .yesOrNo:
      return "number_screen"
    case .letter:
      return "character_screen"
    case .list:
      return "list_screen"
    case .coin:
      return "coin_screen"
    case .cube:
      return "cube_screen"
    case .dateAndTime:
      return "date_and_time_screen"
    case .lottery:
      return "lottery_screen"
    case .contact:
      return "contact_screen"
    case .password:
      return "password_screen"
    case .colors:
      return "colors_screen"
    case .bottle:
      return "bottle_screen"
    case .rockPaperScissors:
      return "rock_paper_scissors_screen"
    case .imageFilters:
      return "image_filters"
    case .films:
      return "films_screen"
    case .nickName:
      return "nick_name"
    case .names:
      return "names"
    case .congratulations:
      return "congratulations"
    case .goodDeeds:
      return "good_deeds"
    case .riddles:
      return "riddles"
    case .joke:
      return "joke"
    case .gifts:
      return "gifts"
    case .slogans:
      return "slogans"
    case .truthOrDare:
      return "truth_or_dare"
    case .quotes:
      return "quotes"
    case .fortuneWheel:
      return "fortuneWheel"
    case .updateApp:
      return "update_app"
    case .settingsSections:
      return "settings_sections"
    case .settingsIconSelection:
      return "settings_icon_selection"
    case .settingsPremiumSection:
      return "settings_premium_section"
    case .settingsShareApp:
      return "settings_share_app"
    case .settingsfeedBackButton:
      return "settings_feed_back_button"
    }
  }
  
  // MARK: - Main Screen
  
  /// Раздел: `Команды`
  case teams
  
  /// Раздел: `Число`
  case number
  
  /// Раздел: `Да или Нет`
  case yesOrNo
  
  /// Раздел: `Буква`
  case letter
  
  /// Раздел: `Список`
  case list
  
  /// Раздел: `Монета`
  case coin
  
  /// Раздел: `Кубики`
  case cube
  
  /// Раздел: `Дата и Время`
  case dateAndTime
  
  /// Раздел: `Лотерея`
  case lottery
  
  /// Раздел: `Контакты`
  case contact
  
  /// Раздел: `Пароли`
  case password
  
  /// Раздел: `Цвета`
  case colors
  
  /// Раздел: `Бутылочка`
  case bottle
  
  /// Раздел `Камень, ножницы, бумага`
  case rockPaperScissors
  
  /// Раздел `Фильтры изображений`
  case imageFilters
  
  /// Раздел `Фильмы`
  case films
  
  /// Раздел `Никнейм`
  case nickName
  
  /// Раздел генерации имен
  case names
  
  /// Раздел поздравлений
  case congratulations
  
  /// Раздел "Хорошие дела"
  case goodDeeds
  
  /// Раздел "Загадки"
  case riddles
  
  /// Раздел "Анекдоты"
  case joke
  
  /// Раздел "Подарки"
  case gifts
  
  /// Раздел "Слоганы"
  case slogans
  
  /// Раздел "Правда или действие"
  case truthOrDare
  
  /// Раздел "Цитаты"
  case quotes
  
  /// Раздел "Колесо Фортуны"
  case fortuneWheel
  
  /// Обновить приложением
  case updateApp
  
  /// Настройка секций
  case settingsSections
  
  /// Выбор иконки в приложении
  case settingsIconSelection
  
  /// Раздел премиум
  case settingsPremiumSection
  
  /// Поделиться приложением
  case settingsShareApp
  
  /// Кнопка с обратной связью
  case settingsfeedBackButton
}
