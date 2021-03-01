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
    var data: [Datum]
    let currentPage: Int
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case currentPage = "current_page"
        case total = "total"
    }
}

extension Films {
    static let plug = Films(data: [], currentPage: 1, total: 1)
}

extension Films: Equatable {
    static func == (lhs: Films, rhs: Films) -> Bool {
        return
            lhs.data == rhs.data &&
            lhs.currentPage == rhs.currentPage &&
            lhs.total == rhs.total
    }
}

// MARK: - Datum
struct Datum: Codable {
    var id: Int?
    var ruTitle: String?
    var kinopoiskID: String?
    var imdbID: String?
    var origTitle: String?
    var iframeSrc: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ruTitle = "ru_title"
        case kinopoiskID = "kinopoisk_id"
        case imdbID = "imdb_id"
        case origTitle = "orig_title"
        case iframeSrc = "iframe_src"
    }
}

extension Datum: Equatable {
    static func == (lhs: Datum, rhs: Datum) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.ruTitle == rhs.ruTitle &&
            lhs.kinopoiskID == rhs.kinopoiskID &&
            lhs.imdbID == rhs.imdbID &&
            lhs.origTitle == rhs.origTitle &&
            lhs.iframeSrc == rhs.iframeSrc
    }
}
