//
//  FramesFilms.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - FramesFilms
struct FramesFilms: Codable {
    let frames: [Frame]?
}

// MARK: - Frame
struct Frame: Codable, Equatable {
    let image: String?
    let preview: String?
    
    enum CodingKeys: String, CodingKey {
        case image, preview
    }
}

extension FramesFilms: Equatable {
    static func == (lhs: FramesFilms, rhs: FramesFilms) -> Bool {
        return
            lhs.frames == rhs.frames
    }
}
