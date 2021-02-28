//
//  Films.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - Films
struct Films: Codable {
    let result: Bool
    var data: [Datum]
    let currentPage: Int
    let firstPageURL: String
    let from, lastPage: Int
    let lastPageURL, nextPageURL, path: String
    let perPage: Int
        let prevPageURL: JSONNull?
    let to, total, totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case result, data
        case currentPage = "current_page"
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
        case totalCount = "total_count"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.datumTask(with: url) { datum, response, error in
//     if let datum = datum {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Datum
struct Datum: Codable {
    var tapped: Bool?
    let id: Int
    let ruTitle, origTitle, imdbID, kinopoiskID: String
    let defaultMediaID: Int?
    let created, released, updated: String
    let blocked: Int
    let contentID: JSONNull?
    let contentType: String
    let countryID: JSONNull?
    let media: [Media]
    let previewIframeSrc: String
    let iframeSrc, iframe: String
    let translations: [Translation]
    let year: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case ruTitle = "ru_title"
        case origTitle = "orig_title"
        case imdbID = "imdb_id"
        case kinopoiskID = "kinopoisk_id"
        case defaultMediaID = "default_media_id"
        case created, released, updated, blocked
        case contentID = "content_id"
        case contentType = "content_type"
        case countryID = "country_id"
        case media
        case previewIframeSrc = "preview_iframe_src"
        case iframeSrc = "iframe_src"
        case iframe, translations, year
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.mediaTask(with: url) { media, response, error in
//     if let media = media {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Media
struct Media: Codable {
    let id, translationID, contentID: Int
    let contentType: String
    let tvSeriesID: JSONNull?
    let sourceQuality: String
    let maxQuality: Int
    let path: String
    let duration: Int
    let created, accepted: String
    let deletedAt: JSONNull?
    let blocked: Int
    let qualities: [Quality]
    let translation: Translation
    
    enum CodingKeys: String, CodingKey {
        case id
        case translationID = "translation_id"
        case contentID = "content_id"
        case contentType = "content_type"
        case tvSeriesID = "tv_series_id"
        case sourceQuality = "source_quality"
        case maxQuality = "max_quality"
        case path, duration, created, accepted
        case deletedAt = "deleted_at"
        case blocked, qualities, translation
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.qualityTask(with: url) { quality, response, error in
//     if let quality = quality {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Quality
struct Quality: Codable {
    let id: Int
    let url: String
    let resolution, mediaID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, url, resolution
        case mediaID = "media_id"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.translationTask(with: url) { translation, response, error in
//     if let translation = translation {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Translation
struct Translation: Codable {
    let id: Int
    let title: String
    let priority: Int
    let iframeSrc, iframe, shortTitle, smartTitle: String
    let shorterTitle: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, priority
        case iframeSrc = "iframe_src"
        case iframe
        case shortTitle = "short_title"
        case smartTitle = "smart_title"
        case shorterTitle = "shorter_title"
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func filmsTask(with url: URL, completionHandler: @escaping (Films?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
