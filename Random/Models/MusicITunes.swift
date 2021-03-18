//
//  MusicITunes.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - MusicITunes
struct MusicITunes: Codable {
    var results: MusicITunesResults?
}

// MARK: - Results
struct MusicITunesResults: Codable {
    var songs: [MusicITunesSong]?
}

// MARK: - Song
struct MusicITunesSong: Codable {
    var data: [MusicITunesDatum]?
}

// MARK: - Datum
struct MusicITunesDatum: Codable {
    var attributes: MusicITunesAttributes?
    var href, id: String?
}

// MARK: - Attributes
struct MusicITunesAttributes: Codable {
    var isrc: String?
    var playParams: MusicITunesPlayParams?
    var url: String?
    var artistName: String?
    var artwork: MusicITunesArtwork?
    var name, releaseDate: String?
    var genreNames: [String]?
    var previews: [MusicITunesPreview]?
}

// MARK: - Artwork
struct MusicITunesArtwork: Codable {
    var url: String?
}

// MARK: - PlayParams
struct MusicITunesPlayParams: Codable {
    var id: String?
}

// MARK: - Preview
struct MusicITunesPreview: Codable {
    var url: String?
}

extension MusicITunes: Equatable {
    static func == (lhs: MusicITunes, rhs: MusicITunes) -> Bool {
        return
            lhs.results == rhs.results
    }
}

extension MusicITunesResults: Equatable {
    static func == (lhs: MusicITunesResults, rhs: MusicITunesResults) -> Bool {
        return
            lhs.songs == rhs.songs
    }
}

extension MusicITunesSong: Equatable {
    static func == (lhs: MusicITunesSong, rhs: MusicITunesSong) -> Bool {
        return
            lhs.data == rhs.data
    }
}

extension MusicITunesDatum: Equatable {
    static func == (lhs: MusicITunesDatum, rhs: MusicITunesDatum) -> Bool {
        return
            lhs.attributes == rhs.attributes &&
            lhs.href == rhs.href &&
            lhs.id == rhs.id
    }
}

extension MusicITunesAttributes: Equatable {
    static func == (lhs: MusicITunesAttributes, rhs: MusicITunesAttributes) -> Bool {
        return
            lhs.isrc == rhs.isrc &&
            lhs.playParams == rhs.playParams &&
            lhs.url == rhs.url &&
            lhs.artistName == rhs.artistName &&
            lhs.artwork == rhs.artwork &&
            lhs.name == rhs.name &&
            lhs.releaseDate == rhs.releaseDate &&
            lhs.genreNames == rhs.genreNames &&
            lhs.previews == rhs.previews
    }
}

extension MusicITunesArtwork: Equatable {
    static func == (lhs: MusicITunesArtwork, rhs: MusicITunesArtwork) -> Bool {
        return
            lhs.url == rhs.url
    }
}

extension MusicITunesPlayParams: Equatable {
    static func == (lhs: MusicITunesPlayParams, rhs: MusicITunesPlayParams) -> Bool {
        return
            lhs.id == rhs.id
    }
}

extension MusicITunesPreview: Equatable {
    static func == (lhs: MusicITunesPreview, rhs: MusicITunesPreview) -> Bool {
        return
            lhs.url == rhs.url
    }
}
