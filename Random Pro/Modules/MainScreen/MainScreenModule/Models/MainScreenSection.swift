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
    
    /// Название секции
    let titleSection: String
    
    /// Иконка секции
    let imageSection: Data
    
    /// Тип лайбла
    let advLabel: ADVLabel
  }
  
  // MARK: - MainScreenSection
  
  enum SectionType: CaseIterable, UserDefaultsCodable {
    
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
  }
  
  // MARK: - ADVLabel
  
  enum ADVLabel: CaseIterable, UserDefaultsCodable {
    
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
