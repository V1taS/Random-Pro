//
//  Film.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Film: Equatable {
        
        var films: [Datum] = []
        var filmsVideoHistory: [Datum] = []
        var filmsHistory: [FilmsInfo] = []
        var filmInfo = FilmsInfo.plug
        
        var filmsBest: [BestFilm] = []
        var filmsBestHistory: [BestFilm] = []
        var filmsBestInfo = BestFilm.plug
        
        
        var selectedGenres = 0
        var showSettings = false
        var showActivityIndicator = false
        
    }
}
