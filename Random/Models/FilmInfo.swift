//
//  FilmInfo.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - FilmsInfo
struct FilmsInfo: Codable {
    var data: DataClass?
    var rating: Rating?
    var review: Review?
}

// MARK: - DataClass
struct DataClass: Codable {
    var filmId: Int?
    var nameRu: String?
    var nameEn: String?
    var webUrl: String?
    var posterUrlPreview: String?
    var year, filmLength, slogan, description: String?
    let ratingAgeLimits: Int?
}

// MARK: - Country
struct Country: Codable {
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
    var ratingImdb: Double?
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

extension FilmsInfo: Equatable {
    static func == (lhs: FilmsInfo, rhs: FilmsInfo) -> Bool {
        return
            lhs.data == rhs.data &&
            lhs.rating == rhs.rating &&
            lhs.review == rhs.review
    }
}

extension Rating: Equatable {
    static func == (lhs: Rating, rhs: Rating) -> Bool {
        return
            lhs.ratingImdb == rhs.ratingImdb
    }
}

extension Review: Equatable {
    static func == (lhs: Review, rhs: Review) -> Bool {
        return
            lhs.ratingGoodReview == rhs.ratingGoodReview
    }
}

extension DataClass: Equatable {
    static func == (lhs: DataClass, rhs: DataClass) -> Bool {
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

extension FilmsInfo {
    static let plug = FilmsInfo(data: DataClass(filmId: nil, nameRu: nil, nameEn: nil, webUrl: nil, posterUrlPreview: nil, year: nil, filmLength: nil, slogan: nil, description: nil, ratingAgeLimits: nil),
                                rating: Rating(ratingImdb: nil),
                                review: Review(ratingGoodReview: nil))
}
