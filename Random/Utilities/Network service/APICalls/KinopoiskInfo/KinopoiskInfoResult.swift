//
//  KinopoiskInfoResult.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - KinopoiskInfoResult
struct KinopoiskInfoResult: Codable {
    var data: Data?
    var rating: Rating? = nil
    var review: Review? = nil
    
    // MARK: - Data
    struct Data: Codable {
        var filmId: Int?
        var nameRu: String?
        var nameEn: String?
        var webUrl: String?
        var posterUrlPreview: String?
        var year, filmLength, slogan, description: String?
        var ratingAgeLimits: Int?
        var countries: [FilmsInfoCountry]?
        var genres: [FilmsInfoCountry]?
    }

    // MARK: - FilmsInfoCountry
    struct FilmsInfoCountry: Codable {
        var name: String?
    }

    // MARK: - Season
    struct Season: Codable {
        var number: Int?
        var episodes: [Episode]?
    }

    // MARK: - Episode
    struct Episode: Codable {
        var seasonNumber, episodeNumber: Int?
        var nameRu, nameEn, synopsis, releaseDate: String?
    }

    // MARK: - Rating
    struct Rating: Codable {
        var rating: Double?
        var ratingImdb: Double?
        var ratingFilmCritics: String?
        var ratingAwait: String?
        var ratingRFCritics: String?
    }

    // MARK: - Budget
    struct Budget: Codable {
        var grossRu: Int?
        var grossUsa: Int?
        var grossWorld: Int?
        var budget: String?
        var marketing: Int?
    }

    // MARK: - Review
    struct Review: Codable {
        var ratingGoodReview: String?
    }

    // MARK: - ExternalID
    struct ExternalId: Codable {
        var imdbId: String?
    }

    // MARK: - Images
    struct Images: Codable {
        var posters, backdrops: [Backdrop]?
    }

    // MARK: - Backdrop
    struct Backdrop: Codable {
        var language: String?
        var url: String?
        var height, width: Int?
    }
}

extension KinopoiskInfoResult.FilmsInfoCountry: Equatable {
    static func == (lhs: KinopoiskInfoResult.FilmsInfoCountry, rhs: KinopoiskInfoResult.FilmsInfoCountry) -> Bool {
        return
            lhs.name == rhs.name
    }
}

extension KinopoiskInfoResult: Equatable {
    static func == (lhs: KinopoiskInfoResult, rhs: KinopoiskInfoResult) -> Bool {
        return
            lhs.data == rhs.data &&
            lhs.rating == rhs.rating &&
            lhs.review == rhs.review
    }
}

extension KinopoiskInfoResult.Rating: Equatable {
    static func == (lhs: KinopoiskInfoResult.Rating, rhs: KinopoiskInfoResult.Rating) -> Bool {
        return
            lhs.rating == rhs.rating &&
            lhs.ratingImdb == rhs.ratingImdb &&
            lhs.ratingFilmCritics == rhs.ratingFilmCritics &&
            lhs.ratingAwait == rhs.ratingAwait &&
            lhs.ratingRFCritics == rhs.ratingRFCritics
    }
}

extension KinopoiskInfoResult.Review: Equatable {
    static func == (lhs: KinopoiskInfoResult.Review, rhs: KinopoiskInfoResult.Review) -> Bool {
        return
            lhs.ratingGoodReview == rhs.ratingGoodReview
    }
}

extension KinopoiskInfoResult.Data: Equatable {
    static func == (lhs: KinopoiskInfoResult.Data, rhs: KinopoiskInfoResult.Data) -> Bool {
        return
            lhs.filmId == rhs.filmId &&
            lhs.nameRu == rhs.nameRu &&
            lhs.nameEn == rhs.nameEn &&
            lhs.webUrl == rhs.webUrl &&
            lhs.posterUrlPreview == rhs.posterUrlPreview &&
            lhs.year == rhs.year &&
            lhs.filmLength == rhs.filmLength &&
            lhs.slogan == rhs.slogan &&
            lhs.description == rhs.description &&
            lhs.ratingAgeLimits == rhs.ratingAgeLimits
    }
}

extension KinopoiskInfoResult {
    static let plug = KinopoiskInfoResult(data: KinopoiskInfoResult.Data(filmId: nil,
                                                nameRu: nil,
                                                nameEn: nil,
                                                webUrl: nil,
                                                posterUrlPreview: nil,
                                                year: nil,
                                                filmLength: nil,
                                                slogan: nil,
                                                description: nil,
                                                ratingAgeLimits: nil))
}

