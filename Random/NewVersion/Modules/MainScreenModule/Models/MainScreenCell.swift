//
//  MainScreenCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
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
      .films(advLabel: .none),
      .teams(advLabel: .none),
      .number(advLabel: .new),
      .yesOrNo(advLabel: .hit),
      .letter(advLabel: .premium),
      .list(advLabel: .none),
      .coin(advLabel: .none),
      .cube(advLabel: .none),
      .dateAndTime(advLabel: .none),
      .lottery(advLabel: .none),
      .contact(advLabel: .none),
      .password(advLabel: .none),
      .russianLotto(advLabel: .none)
    ]
    
    // MARK: - Cases
    
    /// Раздел: `Фильмы`
    case films(advLabel: ADVLabel)
    
    /// Раздел: `Команды`
    case teams(advLabel: ADVLabel)
    
    /// Раздел: `Число`
    case number(advLabel: ADVLabel)
    
    /// Раздел: `Да или Нет`
    case yesOrNo(advLabel: ADVLabel)
    
    /// Раздел: `Буква`
    case letter(advLabel: ADVLabel)
    
    /// Раздел: `Список`
    case list(advLabel: ADVLabel)
    
    /// Раздел: `Монета`
    case coin(advLabel: ADVLabel)
    
    /// Раздел: `Кубики`
    case cube(advLabel: ADVLabel)
    
    /// Раздел: `Дата и Время`
    case dateAndTime(advLabel: ADVLabel)
    
    /// Раздел: `Лотерея`
    case lottery(advLabel: ADVLabel)
    
    /// Раздел: `Контакты`
    case contact(advLabel: ADVLabel)
    
    /// Раздел: `Пароли`
    case password(advLabel: ADVLabel)
    
    /// Раздел: `Русское Лото`
    case russianLotto(advLabel: ADVLabel)
    
    // MARK: - ADVLabel
    
    enum ADVLabel: CaseIterable, Equatable {
      
      /// Лайбл: `ХИТ`
      case hit
      
      /// Лайбл: `НОВОЕ`
      case new
      
      /// Лайбл: `ПРЕМИУМ`
      case premium
      
      /// Лайбл: `ЗАКРЫТО`
      case close
      
      /// Лайбл: `пусто`
      case none
    }
  }
}
