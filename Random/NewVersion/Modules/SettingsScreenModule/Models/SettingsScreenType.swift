//
//  SettingsScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

// MARK: - SettingsScreenType

enum SettingsScreenType {
  
  // MARK: - Cases
  
  /// Раздел: `Фильмы`
  case films(Films)
  
  /// Раздел: `Команды`
  case teams(Teams)
  
  /// Раздел: `Число`
  case number(Number)
  
  /// Раздел: `Да или Нет`
  case yesOrNo(YesOrNo)
  
  /// Раздел: `Буква`
  case character(Character)
  
  /// Раздел: `Список`
  case list(List)
  
  /// Раздел: `Монета`
  case coin(Coin)
  
  /// Раздел: `Кубики`
  case cube(Cube)
  
  /// Раздел: `Дата и Время`
  case dateAndTime(DateAndTime)
  
  /// Раздел: `Лотерея`
  case lottery(Lottery)
  
  /// Раздел: `Контакты`
  case contact(Contact)
  
  /// Раздел: `Пароли`
  case password(Password)
  
  /// Раздел: `Русское Лото`
  case russianLotto(RussianLotto)
}
