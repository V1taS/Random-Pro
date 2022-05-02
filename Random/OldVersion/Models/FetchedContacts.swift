//
//  Contact.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 22.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation
import Contacts

struct FetchedContacts: Decodable, Encodable {
    var firstName: String
    var lastName: String
    var telephone: String
}

extension FetchedContacts: Equatable {
    static func == (lhs: FetchedContacts, rhs: FetchedContacts) -> Bool {
        return
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.telephone == rhs.telephone
    }
}
