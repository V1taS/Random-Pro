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
    let data: DataClass
    let rating: Rating?
    let budget: Budget?
    let review: Review?
    let externalId: ExternalId?
    let images: Images?

    enum CodingKeys: String, CodingKey {
        case data, rating, budget, review
        case externalId
        case images
    }
}

// MARK: - Budget
struct Budget: Codable {
    let grossRu, grossUsa, grossWorld: Int
    let budget: String
    let marketing: Int
}

// MARK: - DataClass
struct DataClass: Codable {
    let filmId: Int?
    let nameRu, nameEn: String?
    let webUrl: String?
    let posterUrl: String?
    let posterUrlPreview: String?
    let year, filmLength, slogan, description: String?
    let type, ratingMpaa: String?
    let ratingAgeLimits: Int?
    let premiereRu, distributors, premiereWorld, premiereDigital: String?
    let premiereWorldCountry, premiereDvd, premiereBluRay, distributorRelease: String?
    let countries, genres: [Country]
    let facts: [String]?
    let seasons: [Season]

    enum CodingKeys: String, CodingKey {
        case filmId
        case nameRu, nameEn
        case webUrl
        case posterUrl
        case posterUrlPreview
        case year, filmLength, slogan, description
        case type
        case ratingMpaa
        case ratingAgeLimits, premiereRu, distributors, premiereWorld, premiereDigital, premiereWorldCountry
        case premiereDvd
        case premiereBluRay, distributorRelease, countries, genres, facts, seasons
    }
}

// MARK: - Country
struct Country: Codable {
    let name: String?
}

// MARK: - Season
struct Season: Codable {
    let number: Int?
    let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Codable {
    let seasonNumber, episodeNumber: Int?
    let nameRu, nameEn, synopsis, releaseDate: String?
}

// MARK: - ExternalID
struct ExternalId: Codable {
    let imdbId: String?

    enum CodingKeys: String, CodingKey {
        case imdbId
    }
}

// MARK: - Images
struct Images: Codable {
    let posters, backdrops: [Backdrop]
}

// MARK: - Backdrop
struct Backdrop: Codable {
    let language: String?
    let url: String?
    let height, width: Int?
}

// MARK: - Rating
struct Rating: Codable {
    let rating: Double?
    let ratingVoteCount: Int?
    let ratingImdb: Double?
    let ratingImdbVoteCount: Int?
    let ratingFilmCritics: String?
    let ratingFilmCriticsVoteCount: Int?
    let ratingAwait: String?
    let ratingAwaitCount: Int?
    let ratingRFCritics: String?
    let ratingRFCriticsVoteCount: Int?

    enum CodingKeys: String, CodingKey {
        case rating, ratingVoteCount, ratingImdb, ratingImdbVoteCount, ratingFilmCritics, ratingFilmCriticsVoteCount, ratingAwait, ratingAwaitCount
        case ratingRFCritics
        case ratingRFCriticsVoteCount
    }
}

// MARK: - Review
struct Review: Codable {
    let reviewsCount: Int?
    let ratingGoodReview: String?
    let ratingGoodReviewVoteCount: Int?
}
