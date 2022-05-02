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
        
        var films: [VideoCDNResult.Data] = []
        var filmsVideoHistory: [VideoCDNResult.Data] = []
        
        var filmsTemp: [KinopoiskInfoResult] = []
        var filmsHistory: [KinopoiskInfoResult] = []
        var filmInfo = KinopoiskInfoResult.plug
        
        var filmsBest: [KinopoiskBestFilmsResult.BestFilm] = []
        var filmsBestHistory: [KinopoiskBestFilmsResult.BestFilm] = []
        var filmsBestInfo = KinopoiskBestFilmsResult.plug
        
        var filmsPopular: [KinopoiskBestFilmsResult.BestFilm] = []
        var filmsPopularHistory: [KinopoiskBestFilmsResult.BestFilm] = []
        var filmsPopularInfo = KinopoiskBestFilmsResult.plug
        
        var selectedGenres = 0
        
        var pageNumberBest: [Int] = []
        var nameFilmBest = ""
        var imageFilmBest = ""
        var ratingFilmBest = 0.0
        var ratingIsShowBest = false
        var showVideoPlayerIconBest = false
        
        var pageNumberPopular: [Int] = []
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
