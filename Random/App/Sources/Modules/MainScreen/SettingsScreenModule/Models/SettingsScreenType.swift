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
  
  // MARK: - Cases
  
  /// Раздел: `Никнейм`
  case nickname(itemsGenerated: String, lastItem: String)

  /// Раздел: `Слоганы`
  case slogans(itemsGenerated: String,
               lastItem: String,
               currentCountry: String,
               listOfItems: [String],
               valueChanged: ((_ index: Int) -> Void)?)

  /// Раздел: `Анекдоты`
  case joke(itemsGenerated: String,
            lastItem: String,
            currentCountry: String,
            listOfItems: [String],
            valueChanged: ((_ index: Int) -> Void)?)
  
  /// Раздел: `Добрые дела`
  case goodDeeds(itemsGenerated: String,
                 lastItem: String,
                 currentCountry: String,
                 listOfItems: [String],
                 valueChanged: ((_ index: Int) -> Void)?)
  
  /// Раздел: `Загадки`
  case riddles(itemsGenerated: String,
               lastItem: String,
               currentCountry: String,
               listOfItems: [String],
               valueChanged: ((_ index: Int) -> Void)?)
  
  /// Раздел: `Имена`
  case names(itemsGenerated: String,
             lastItem: String,
             currentCountry: String,
             listOfItems: [String],
             valueChanged: ((_ index: Int) -> Void)?)

  /// Раздел: `Подарки`
  case gifts(itemsGenerated: String,
             lastItem: String,
             currentCountry: String,
             listOfItems: [String],
             valueChanged: ((_ index: Int) -> Void)?)
  
  /// Раздел: `Gоздравлений`
  case congratulations(itemsGenerated: String,
                       lastItem: String,
                       currentCountry: String,
                       listOfItems: [String],
                       valueChanged: ((_ index: Int) -> Void)?)
  
  /// Раздел: `Фильмы`
  case films
  
  /// Раздел: `Команды`
  case teams(generatedTeamsCount: String, allPlayersCount: String, generatedPlayersCount: String)
  
  /// Раздел: `Число`
  case number(withoutRepetition: Bool, itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Да или Нет`
  case yesOrNo(itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Буква`
  case letter(withoutRepetition: Bool, itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Список`
  case list(withoutRepetition: Bool, generatedTextCount: String, allTextCount: String, lastItem: String)
  
  /// Раздел: `Монета`
  case coin(isShowlistGenerated: Bool, itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Кубики`
  case cube(isShowlistGenerated: Bool, itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Дата и Время`
  case dateAndTime(itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Лотерея`
  case lottery(itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Контакты`
  case contact(itemsGenerated: String, lastItem: String)
  
  /// Раздел: `Пароли`
  case password(itemsGenerated: String, lastItem: String)
}
