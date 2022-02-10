//
//  Metrics.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import YandexMobileMetrica

enum MetricsApplicationSections: String {
    case categoriesScreen = "Категории"
    case purchasesScreen = "Экран покупки Премиум версии"
    case mailScreen = "Обратная связь"
    case shareScreen = "Поделиться"
    case totalNumberOfClicks = "Общее количество нажатий"
    
    // Категории
    case filmScreen = "Фильмы"
    case teamsScreen = "Команды"
    case numbersScreen = "Число"
    case yesOrNotScreen = "Да или нет"
    case charactersScreen = "Буква"
    case listScreen = "Список"
    case coinScreen = "Монета"
    case cubeScreen = "Кубики"
    case dateAndTimeScreen = "Дата и время"
    case lotteryScreen = "Лотерея"
    case contactScreen = "Контакт"
    case musicScreen = "Музыка"
    case travelScreen = "Путешествие"
}

final class Metrics {
    
    static func trackEvent(name: MetricsApplicationSections, properties: [String: String]) {
        YMMYandexMetrica.reportEvent(name.rawValue, parameters: properties) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
    
    static func trackEvent(name: MetricsApplicationSections) {
        YMMYandexMetrica.reportEvent(name.rawValue, parameters: nil) { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        }
    }
}
