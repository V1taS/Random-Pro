//
//  Player.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

struct Player: Decodable, Encodable {
    let name: String
    let photo: String
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
            return
                lhs.name == rhs.name &&
                lhs.photo == rhs.photo
        }
}
