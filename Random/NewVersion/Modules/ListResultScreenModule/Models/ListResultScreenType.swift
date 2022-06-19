//
//  ListResultScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - ListResultScreenType

enum ListResultScreenType {
  
  // MARK: - Cases
  
  /// Раздел: `Фильмы`
  case films
  
  /// Раздел: `Команды`
  case teams
  
  /// Раздел: `Число`
  case number(list: [String])
  
  /// Раздел: `Да или Нет`
  case yesOrNo
  
  /// Раздел: `Буква`
  case character
  
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
  
  /// Раздел: `Русское Лото`
  case russianLotto
}
