//
//  FilmActions.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppActions {
    struct FilmActions: Equatable {
        enum GetDowloadAllFilms {
            case firstStart
            case ifNotEnough
            case non
        }
    }
}
