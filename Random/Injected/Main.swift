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
        var storeCellMenu = [NSLocalizedString("Фильмы", comment: ""),
                             NSLocalizedString("Команды",
                                                      comment: ""),
                             NSLocalizedString("Число", comment: ""),
                             NSLocalizedString("Да или Нет", comment: ""),
                             NSLocalizedString("Буква", comment: ""),
                             NSLocalizedString("Список", comment: ""),
                             NSLocalizedString("Монета", comment: ""),
                             NSLocalizedString("Кубики", comment: ""),
                             NSLocalizedString("Дата и время",
                                                      comment: ""),
                             NSLocalizedString("Лотерея",
                                                      comment: ""),
                             NSLocalizedString("Контакт",
                                                      comment: ""),
                             NSLocalizedString("Музыка",
                                                      comment: "")]
        
        var storeCellMenuHidden: [String] = []
    }
}
