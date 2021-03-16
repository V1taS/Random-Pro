//
//  Music.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - Music
struct Music: Codable {
    let results: MusicResults?
}

// MARK: - Results
struct MusicResults: Codable {
    let songs: [MusicSongs]?
}

// MARK: - Songs
struct MusicSongs: Codable {
    let data: [MusicData]?
}

// MARK: - Data
struct MusicData: Codable {
    let attributes: MusicAttributes?
}

// MARK: - Attributes
struct MusicAttributes: Codable {
    let artistName: String?
    let artwork: MusicArtwork?
    let name: String?
    let previews: [MusicPreviews]?
    let url: String?
}

// MARK: - Artwork
struct MusicArtwork: Codable {
    let url: String?
}

// MARK: - Previews
struct MusicPreviews: Codable {
    let url: String?
}
