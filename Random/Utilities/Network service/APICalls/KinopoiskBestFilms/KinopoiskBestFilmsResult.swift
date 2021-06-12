//
//  KinopoiskBestFilmsResult.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - KinopoiskBestFilmsResult
struct KinopoiskBestFilmsResult: Codable {
    var pagesCount: Int?
    var films: [BestFilm]?
    
    // MARK: - Film
    struct BestFilm: Codable {
        var filmId: Int?
        var nameRu: String?
        var nameEn: String?
        var year: String?
        var filmLength: String?
        var countries: [CountryBestFilm]?
        var genres: [GenreBestFilm]?
        var rating: String?
        var ratingVoteCount: Int?
        let posterUrl: String?
        var posterUrlPreview: String?
    }
    
    // MARK: - Country
    struct CountryBestFilm: Codable {
        var country: String?
    }
    
    // MARK: - Genre
    struct GenreBestFilm: Codable {
        var genre: String?
    }
}

extension KinopoiskBestFilmsResult: Equatable {
    static func == (lhs: KinopoiskBestFilmsResult, rhs: KinopoiskBestFilmsResult) -> Bool {
        return
            lhs.pagesCount == rhs.pagesCount &&
            lhs.films == rhs.films
    }
}

extension KinopoiskBestFilmsResult.BestFilm: Equatable {
    static func == (lhs: KinopoiskBestFilmsResult.BestFilm, rhs: KinopoiskBestFilmsResult.BestFilm) -> Bool {
        return
            lhs.filmId == rhs.filmId &&
            lhs.nameRu == rhs.nameRu &&
            lhs.nameEn == rhs.nameEn &&
            lhs.year == rhs.year &&
            lhs.filmLength == rhs.filmLength &&
            lhs.countries == rhs.countries &&
            lhs.genres == rhs.genres &&
            lhs.rating == rhs.rating &&
            lhs.ratingVoteCount == rhs.ratingVoteCount &&
            lhs.posterUrl == rhs.posterUrl &&
            lhs.posterUrlPreview == rhs.posterUrlPreview
    }
}

extension KinopoiskBestFilmsResult.CountryBestFilm: Equatable {
    static func == (lhs: KinopoiskBestFilmsResult.CountryBestFilm, rhs: KinopoiskBestFilmsResult.CountryBestFilm) -> Bool {
        return
            lhs.country == rhs.country
    }
}

extension KinopoiskBestFilmsResult.GenreBestFilm: Equatable {
    static func == (lhs: KinopoiskBestFilmsResult.GenreBestFilm, rhs: KinopoiskBestFilmsResult.GenreBestFilm) -> Bool {
        return
            lhs.genre == rhs.genre
    }
}

extension KinopoiskBestFilmsResult {
    static let plug = BestFilm(filmId: 0,
                               nameRu: "",
                               nameEn: "",
                               year: "",
                               filmLength: "",
                               countries: [],
                               genres: [],
                               rating: "",
                               ratingVoteCount: 0,
                               posterUrl: "",
                               posterUrlPreview: "")
}
