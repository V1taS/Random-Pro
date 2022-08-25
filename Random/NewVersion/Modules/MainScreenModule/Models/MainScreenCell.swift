//
//  MainScreenCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - MainScreenCellModel

struct MainScreenCellModel {
  
  let cell: MainScreenCell
  let imageCard: UIImage
  let titleCard: String
  let isShowADVLabel: Bool
  let titleADVText: String?
  
  // MARK: - MainScreenCell
  
  enum MainScreenCell: CaseIterable, Equatable {
    
    /// Общий список ячеек
    static var allCases: [MainScreenCellModel.MainScreenCell] = [
      .films(advLabel: .new, isEnabled: true),
      .teams(advLabel: .new, isEnabled: true),
      .number(advLabel: .none, isEnabled: true),
      .yesOrNo(advLabel: .none, isEnabled: true),
      .letter(advLabel: .none, isEnabled: true),
      .list(advLabel: .new, isEnabled: true),
      .coin(advLabel: .none, isEnabled: true),
      .cube(advLabel: .new, isEnabled: true),
      .dateAndTime(advLabel: .none, isEnabled: true),
      .lottery(advLabel: .none, isEnabled: true),
      .contact(advLabel: .new, isEnabled: true),
      .password(advLabel: .new, isEnabled: true)
    ]
    
    // MARK: - Cases
    
    /// Раздел: `Фильмы`
    case films(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Команды`
    case teams(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Число`
    case number(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Да или Нет`
    case yesOrNo(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Буква`
    case letter(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Список`
    case list(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Монета`
    case coin(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Кубики`
    case cube(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Дата и Время`
    case dateAndTime(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Лотерея`
    case lottery(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Контакты`
    case contact(advLabel: ADVLabel, isEnabled: Bool)
    
    /// Раздел: `Пароли`
    case password(advLabel: ADVLabel, isEnabled: Bool)
    
    // MARK: - ADVLabel
    
    enum ADVLabel: String, CaseIterable, Equatable {
      
      /// Лайбл: `ХИТ`
      case hit = "Hit"
      
      /// Лайбл: `НОВОЕ`
      case new = "New"
      
      /// Лайбл: `ПРЕМИУМ`
      case premium = "Premium"
      
      /// Лайбл: `Пусто`
      case none = "None"
    }
  }
}
