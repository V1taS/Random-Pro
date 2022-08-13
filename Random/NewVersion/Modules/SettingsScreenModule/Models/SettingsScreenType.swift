//
//  SettingsScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - SettingsScreenType

enum SettingsScreenType {
  
  // MARK: - Property
  
  var allCasesIterable: [SettingsScreenType.AllCasesIterable] {
    switch self {
    case .number, .letter:
      return [.withoutRepetition, .itemsGenerated, .lastItem, .listOfItems, .cleanButton]
    case .yesOrNo, .coin, .dateAndTime, .lottery:
      return [.itemsGenerated, .lastItem, .listOfItems, .cleanButton]
    case .teams:
      return [.generatedTeamsCount, .allPlayersCount, .generatedPlayersCount, .listPlayersAction, .cleanButton]
    default: return []
    }
  }
  
  // MARK: - Cases
  
  /// Раздел: `Фильмы`
  case films(SettingsScreenModel)
  
  /// Раздел: `Команды`
  case teams(SettingsScreenModel)
  
  /// Раздел: `Число`
  case number(SettingsScreenModel)
  
  /// Раздел: `Да или Нет`
  case yesOrNo(SettingsScreenModel)
  
  /// Раздел: `Буква`
  case letter(SettingsScreenModel)
  
  /// Раздел: `Список`
  case list(SettingsScreenModel)
  
  /// Раздел: `Монета`
  case coin(SettingsScreenModel)
  
  /// Раздел: `Кубики`
  case cube(SettingsScreenModel)
  
  /// Раздел: `Дата и Время`
  case dateAndTime(SettingsScreenModel)
  
  /// Раздел: `Лотерея`
  case lottery(SettingsScreenModel)
  
  /// Раздел: `Контакты`
  case contact(SettingsScreenModel)
  
  /// Раздел: `Пароли`
  case password(SettingsScreenModel)
  
  /// Раздел: `Русское Лото`
  case russianLotto(SettingsScreenModel)
  
  // MARK: - AllCasesIterable
  
  enum AllCasesIterable {
    
    /// Без повторений
    case withoutRepetition
    
    /// Всего объектов сгенерировано
    case itemsGenerated
    
    /// Последний объект
    case lastItem
    
    /// Список объектов
    case listOfItems
    
    /// Кнопка очистить
    case cleanButton
    
    /// Количество сгенерированных команд
    case generatedTeamsCount
    
    /// Количество всех игороков
    case allPlayersCount
    
    /// Количество сгенерированных игроков
    case generatedPlayersCount
    
    /// Перейти на список игроков
    case listPlayersAction
  }
}
