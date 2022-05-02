//
//  Player.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

struct Player: Decodable, Encodable {
    var id: String
    let name: String
    let photo: String
    var team: String
}

extension Player: Equatable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name &&
        lhs.photo == rhs.photo &&
        lhs.team == rhs.team &&
        lhs.id == rhs.id
    }
}
