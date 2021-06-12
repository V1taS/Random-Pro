//
//  VideoCDNResult.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - Films
struct VideoCDNResult: Codable {
    var data: [Data]
    let currentPage: Int
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case currentPage = "current_page"
        case total = "total"
    }
    
    // MARK: - Datum
    struct Data: Codable {
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
}

extension VideoCDNResult {
    static let plug = VideoCDNResult(data: [], currentPage: 1, total: 1)
}

extension VideoCDNResult: Equatable {
    static func == (lhs: VideoCDNResult, rhs: VideoCDNResult) -> Bool {
        return
            lhs.data == rhs.data &&
            lhs.currentPage == rhs.currentPage &&
            lhs.total == rhs.total
    }
}

extension VideoCDNResult.Data: Equatable {
    static func == (lhs: VideoCDNResult.Data, rhs: VideoCDNResult.Data) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.ruTitle == rhs.ruTitle &&
            lhs.kinopoiskID == rhs.kinopoiskID &&
            lhs.imdbID == rhs.imdbID &&
            lhs.origTitle == rhs.origTitle &&
            lhs.iframeSrc == rhs.iframeSrc
    }
}
