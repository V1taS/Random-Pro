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
  
  /// Доступность премиума в приложении
  var isPremium: Bool
  
  /// Все секции приложения
  var allSections: [Section]
  
  /// Секция
  struct Section: UserDefaultsCodable, Hashable {
    
    /// Тип секции
    let type: SectionType
    
    /// Секция включена
    let isEnabled: Bool
    
    /// Секция скрыта
    var isHidden: Bool
    
    /// Секция входит в состав премиум (Платные секции)
    let isPremium: Bool
    
    /// Тип лайбла
    let advLabel: ADVLabel
    
    /// Описание в секции
    var advDescription: String?
    
    /// Ссылка по рекламе
    var advStringURL: String?
  }
}
