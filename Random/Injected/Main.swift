//
//  Main.swift
//  Random
//
//  Created by Vitalii Sosin on 07.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Main: Equatable {
        var storeCellMenu = ["Фильмы", "Команды", "Число", "Да или Нет", "Буква", "Список", "Монета",
                             "Кубики", "Дата и время", "Лотерея", "Контакт", "Музыка"]
        
        var storeCellMenuHidden: [String] = []
    }
}
