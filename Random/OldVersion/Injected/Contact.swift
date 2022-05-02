//
//  Contact.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 22.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Contact: Equatable, Decodable {
        var listResults: [FetchedContacts] = []
        var resultFullName = ""
        var resultPhone = ""
        
        var showSettings = false
    }
}
