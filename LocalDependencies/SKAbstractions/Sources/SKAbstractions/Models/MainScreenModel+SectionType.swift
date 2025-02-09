//
//  MainScreenModel+SectionType.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import Foundation

extension MainScreenModel {

  // MARK: - MainScreenSection

  public enum SectionType: String, CaseIterable, UserDefaultsCodable, Hashable {

    /// Проверка что блок рекламный
    public var isADV: Bool {
      switch self {
      case .adv1, .adv2, .adv3, .adv4:
        return true
      default: return false
      }
    }

    // MARK: - Cases

    /// Раздел: `Команды`
    case teams

    /// Раздел: `Число`
    case number

    /// Раздел: `Да или Нет`
    case yesOrNo

    /// Блок рекламы 1
    case adv1

    /// Раздел: `Буква`
    case letter

    /// Раздел: `Список`
    case list

    /// Блок рекламы 2
    case adv2

    /// Раздел: `Монета`
    case coin

    /// Раздел: `Кубики`
    case cube

    /// Раздел: `Дата и Время`
    case dateAndTime

    /// Раздел: `Лотерея`
    case lottery

    /// Блок рекламы 3
    case adv3

    /// Раздел: `Контакты`
    case contact

    /// Раздел: `Пароли`
    case password

    /// Раздел: `Цвета`
    case colors

    /// Раздел: `Бутылочка`
    case bottle

    /// Блок рекламы 4
    case adv4

    /// Раздел `Фильмы`
    case films

    /// Раздел генерации имен
    case names

    /// Раздел поздравлений
    case congratulations

    /// Раздел "Анекдоты"
    case joke

    /// Раздел "Подарки"
    case gifts

    /// Раздел "Колесо Фортуны"
    case fortuneWheel

    /// Раздел "Мемы"
    case memes
  }
}

