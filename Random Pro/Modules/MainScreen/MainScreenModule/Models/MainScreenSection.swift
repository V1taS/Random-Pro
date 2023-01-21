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
  
  /// Доступность премиума
  let isPremium: Bool
  
  /// Все секции приложения
  let allSections: [Section]
  
  /// Секция
  struct Section: UserDefaultsCodable {
    
    /// Тип секции
    let type: SectionType
    
    /// Секция включена
    let isEnabled: Bool
    
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
      let appearance = Appearance()
      switch self {
      case .teams:
        return appearance.teamsDescriptionForNoPremiumAccess
      case .number:
        return appearance.numberDescriptionForNoPremiumAccess
      case .yesOrNo:
        return appearance.yesOrNoDescriptionForNoPremiumAccess
      case .letter:
        return appearance.letterDescriptionForNoPremiumAccess
      case .list:
        return appearance.listDescriptionForNoPremiumAccess
      case .coin:
        return appearance.coinDescriptionForNoPremiumAccess
      case .cube:
        return appearance.cubeDescriptionForNoPremiumAccess
      case .dateAndTime:
        return appearance.dateAndTimeDescriptionForNoPremiumAccess
      case .lottery:
        return appearance.lotteryDescriptionForNoPremiumAccess
      case .contact:
        return appearance.contactDescriptionForNoPremiumAccess
      case .password:
        return appearance.passwordDescriptionForNoPremiumAccess
      case .colors:
        return appearance.colorsDescriptionForNoPremiumAccess
      case .bottle:
        return appearance.bottleDescriptionForNoPremiumAccess
      case .rockPaperScissors:
        return appearance.rockPaperScissorsDescriptionForNoPremiumAccess
      case .imageFilters:
        return appearance.imageFiltersDescriptionForNoPremiumAccess
      case .raffle:
        return appearance.raffleFiltersDescriptionForNoPremiumAccess
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

private extension MainScreenModel {
  struct Appearance {
    let hit = NSLocalizedString("Хит", comment: "")
    let new = NSLocalizedString("Новое", comment: "")
    let premium = NSLocalizedString("Премиум", comment: "")

    let teamsDescriptionForNoPremiumAccess = NSLocalizedString("Команды - Можно генерировать рандомный список команд для игры",
                                                               comment: "")
    let numberDescriptionForNoPremiumAccess = NSLocalizedString("Числа - Можно генерировать рандомные числа",
                                                                comment: "")
    let yesOrNoDescriptionForNoPremiumAccess = NSLocalizedString("Да или нет - Можно генерировать рандомный ответ",
                                                                 comment: "")
    let letterDescriptionForNoPremiumAccess = NSLocalizedString("Буквы - Можно генерировать рандомные буквы",
                                                                comment: "")
    let listDescriptionForNoPremiumAccess = NSLocalizedString("Список - Можно генерировать рандомный список собственных задач",
                                                              comment: "")
    let coinDescriptionForNoPremiumAccess = NSLocalizedString("Монетка - Можно подбрасывать монетку в любое время",
                                                              comment: "")
    let cubeDescriptionForNoPremiumAccess = NSLocalizedString("Кубики - Можно подбрасывать кубики играя в настольную игру",
                                                              comment: "")
    let dateAndTimeDescriptionForNoPremiumAccess = NSLocalizedString("Дата и время - Можно генерировать рандомную дату и время",
                                                                     comment: "")
    let lotteryDescriptionForNoPremiumAccess = NSLocalizedString("Лотерея - Можно генерировать рандомный лот для участия в лотереи",
                                                                 comment: "")
    let contactDescriptionForNoPremiumAccess = NSLocalizedString("Контакт - Можно генерировать рандомный контакт из списка",
                                                                 comment: "")
    let passwordDescriptionForNoPremiumAccess = NSLocalizedString("Пароли - Можно генерировать рандомный пароль для регистрации",
                                                                  comment: "")
    let colorsDescriptionForNoPremiumAccess = NSLocalizedString("Цвета - Можно генерировать рандомные цвета фона",
                                                                comment: "")
    let bottleDescriptionForNoPremiumAccess = NSLocalizedString("Бутылочка - Можно крутить виртуальную бутылочку",
                                                                comment: "")
    let rockPaperScissorsDescriptionForNoPremiumAccess = NSLocalizedString("Цуефа - Можно играть в игру Камень, ножницы, бумага с виртуальным другом",
                                                                           comment: "")
    let imageFiltersDescriptionForNoPremiumAccess = NSLocalizedString("Фильтры - Можно генерировать рандомный фильтр для фото",
                                                                      comment: "")
    let raffleFiltersDescriptionForNoPremiumAccess = NSLocalizedString("Розыгрыш - Можно участвовать в еженедельном розыгрыше призов, просто нажав кнопку Участвовать",
                                                                       comment: "")
  }
}
