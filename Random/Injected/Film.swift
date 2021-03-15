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
        
        var filmsTemp: [FilmsInfo] = []
        var filmsHistory: [FilmsInfo] = []
        var filmInfo = FilmsInfo.plug
        
        var filmsBest: [BestFilm] = []
        var filmsBestHistory: [BestFilm] = []
        var filmsBestInfo = BestFilm.plug
        
        var filmsPopular: [BestFilm] = []
        var filmsPopularHistory: [BestFilm] = []
        var filmsPopularInfo = BestFilm.plug
        
        var selectedGenres = 0
        
        var nameFilmBest = ""
        var imageFilmBest = ""
        var ratingFilmBest = 0.0
        var ratingIsShowBest = false
        var showVideoPlayerIconBest = false
        
        var nameFilmPopular = ""
        var imageFilmPopular = ""
        var ratingFilmPopular = 0.0
        var ratingIsShowPopular = false
        var showVideoPlayerIconPopular = false
        
        var nameFilmAll = ""
        var imageFilmAll = ""
        var ratingFilmAll = 0.0
        var ratingIsShowAll = false
        var showVideoPlayerIconAll = false
        
        var showSettings = false
        var showActivityIndicator = false
    }
}
