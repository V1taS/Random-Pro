//
//  CoinStyleSelectionScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct CoinStyleSelectionScreenModel: UserDefaultsCodable {

  /// Выбран стиль монетки
  let coinStyleSelection: Bool

  /// Премиум режим
  let isPremium: Bool

  /// Стиль монетки
  let coinStyle: CoinStyle

  /// Состояние карточки
  var coinState: CoinState {
    if coinStyleSelection {
      return .checkmark
    } else {
      if isPremium {
        return .none
      } else {
        return .lock
      }
    }
  }

  enum CoinState: CaseIterable, Equatable & Codable {

    /// Заблокирована
    case lock

    /// Выбрана
    case checkmark
    
    /// Ничего
    case none
  }

  enum CoinStyle: CaseIterable, Equatable & Codable {

    /// Стиль по дефолту
    case defaultStyle

    /// Австралийский Кенгуру 2 доллара
    case australianKangaroo

    /// Кипрские 5 евро
    case cyprus5Uero

    /// Итальянский евро
    case italianEuro

    /// Итальянский евро с медведем
    case italianEuroBear

    /// Грузинский лари День Земли
    case georgianLari

    /// Германский Евро со шмелем
    case germanyBumblebeeEuro

    /// Германский Евро Ганс
    case germanyHancEuro

    /// 10 Рублей
    case russian10Rub

    /// Рубль Антошка
    case russianAntoshka

    /// Испанский евро Виктория
    case spanishVictoriaEuro

    /// Испанский евро Торо
    case spanishToroEuro

    /// США Вашингтон доллар
    case usaPresidentDollar

    /// США Хаббл доллар
    case usaHubbleDollar

    /// Данные стиля для сторон монетки
    var coinSidesName: (eagle: String, tails: String) {
      switch self {
      case .defaultStyle:
        return (eagle: "coin_eagle", tails: "coin_tails")
      case .australianKangaroo:
        return (eagle: "AustralianKangarooEagle", tails: "AustralianKangarooTails")
      case .cyprus5Uero:
        return (eagle: "CyprusEagle", tails: "CyprusTails")
      case .italianEuro:
        return (eagle: "ItalianEuroEagle", tails: "ItalianEuroTails")
      case .italianEuroBear:
        return (eagle: "ItalianEuroBearEagle", tails: "ItalianEuroBearTails")
      case .georgianLari:
        return (eagle: "GeorgianLariEagle", tails: "GeorgianLariTails")
      case .germanyBumblebeeEuro:
        return (eagle: "GermanyBumblebeeEuroEagle", tails: "GermanyBumblebeeEuroTails")
      case .germanyHancEuro:
        return (eagle: "GermanyHancEuroEagle", tails: "GermanyHancEuroTails")
      case .russian10Rub:
        return (eagle: "Russian10RubEagle", tails: "Russian10RubTails")
      case .russianAntoshka:
        return (eagle: "RussianAntoshkaEagle", tails: "RussianAntoshkaTails")
      case .spanishVictoriaEuro:
        return (eagle: "SpanishVictoriaEuroEagle", tails: "SpanishVictoriaEuroTails")
      case .spanishToroEuro:
        return (eagle: "SpanishToroEuroEagle", tails: "SpanishToroEuroTails")
      case .usaPresidentDollar:
        return (eagle: "USAPresidentDollarEagle", tails: "USAPresidentDollarTails")
      case .usaHubbleDollar:
        return (eagle: "USAHubbleEagle", tails: "USAHubbleTails")
      }
    }
  }
}
