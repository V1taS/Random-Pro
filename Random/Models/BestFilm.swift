//
//  BestFilm.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct WelcomeBestFilm: Codable {
    var pagesCount: Int?
    var films: [BestFilm]?
}

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

extension WelcomeBestFilm: Equatable {
    static func == (lhs: WelcomeBestFilm, rhs: WelcomeBestFilm) -> Bool {
        return
            lhs.pagesCount == rhs.pagesCount &&
            lhs.films == rhs.films
    }
}

extension BestFilm: Equatable {
    static func == (lhs: BestFilm, rhs: BestFilm) -> Bool {
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

extension CountryBestFilm: Equatable {
    static func == (lhs: CountryBestFilm, rhs: CountryBestFilm) -> Bool {
        return
            lhs.country == rhs.country
    }
}

extension GenreBestFilm: Equatable {
    static func == (lhs: GenreBestFilm, rhs: GenreBestFilm) -> Bool {
        return
            lhs.genre == rhs.genre
    }
}

extension BestFilm {
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
