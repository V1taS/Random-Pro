//
//  MainScreenCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - MainScreenModel

struct MainScreenModel: UserDefaultsCodable {
  
  /// Темная тема включена
  let isDarkMode: Bool?
  
  /// Все секции приложения
  let allSections: [Section]
  
  /// Секция
  struct Section: UserDefaultsCodable {
    
    /// Тип секции
    let type: SectionType
    
    /// Секция включена
    let isEnabled: Bool
    
    /// Разрешен доступ к премиум
    let premiumAccessAllowed: Bool
    
    /// Секция скрыта
    let isHidden: Bool
    
    /// Название секции
    let titleSection: String
    
    /// Иконка секции
    let imageSection: Data
    
    /// Тип лайбла
    let advLabel: ADVLabel
  }
  
  // MARK: - MainScreenSection
  
  enum SectionType: CaseIterable, UserDefaultsCodable {
    
    /// Описание когда нет премиум доступа
    var descriptionForNoPremiumAccess: String {
      switch self {
      case .teams:
        return "Какое то описание для Команд"
      case .number:
        return "Какое то описание для чисел"
      case .yesOrNo:
        return "Какое то описание для да или нет"
      case .letter:
        return "Какое то описание для Букв"
      case .list:
        return "Какое то описание для Списка"
      case .coin:
        return "Какое то описание для Монетки"
      case .cube:
        return "Какое то описание для Кубиков"
      case .dateAndTime:
        return "Какое то описание для Даты и Времени"
      case .lottery:
        return "Какое то описание для Лотереи"
      case .contact:
        return "Какое то описание для Контактов"
      case .password:
        return "Какое то описание для Паролей"
      case .colors:
        return "Какое то описание для Цветов"
      case .bottle:
        return "Какое то описание для Бутылочки"
      case .rockPaperScissors:
        return "Какое то описание для Камень Ножницы Бумага"
      case .imageFilters:
        return "Какое то описание для Фильтров"
      case .raffle:
        return "Какое то описание для Розыгрыш"
      }
    }
    
    // MARK: - Cases
    
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

    /// Раздел `Розыгрыш`
    case raffle
  }
  
  // MARK: - ADVLabel
  
  enum ADVLabel: String, CaseIterable, UserDefaultsCodable {
    
    var title: String {
      let appearance = Appearance()
      switch self {
      case .hit:
        return appearance.hit
      case .new:
        return appearance.new
      case .premium:
        return appearance.premium
      case .none:
        return ""
      }
    }
    
    /// Лайбл: `ХИТ`
    case hit
    
    /// Лайбл: `НОВОЕ`
    case new
    
    /// Лайбл: `ПРЕМИУМ`
    case premium
    
    /// Лайбл: `Пусто`
    case none
  }
}

private extension MainScreenModel.ADVLabel {
  struct Appearance {
    let hit = NSLocalizedString("Хит", comment: "")
    let new = NSLocalizedString("Новое", comment: "")
    let premium = NSLocalizedString("Премиум", comment: "")
  }
}
