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
    
    /// Имя изображения секции
    let imageSectionSystemName: String
    
    /// Название  секции
    let titleSection: String
    
    /// Секция включена
    let isEnabled: Bool
    
    /// Секция скрыта
    let isHidden: Bool
    
    /// Тип лайбла
    let advLabel: ADVLabel
  }
}
