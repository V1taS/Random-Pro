//
//  MainActions.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppActions {
    struct MainActions {
        enum MenuName: String, CaseIterable {
            case films = "Фильмы"
            case teams = "Команды"
            case number = "Число"
            case yesOrNo = "Да или Нет"
            case character = "Буква"
            case list = "Список"
            case coin = "Монета"
            case cube = "Кубики"
            case dateAndTime = "Дата и время"
            case lottery = "Лотерея"
            case contact = "Контакт"
            case music = "Музыка"
            case travel = "Путешествие"
            case password = "Пароли"
            case russianLotto = "Русское Лото"
        }
    }
}
