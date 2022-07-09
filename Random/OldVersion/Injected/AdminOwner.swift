//
//  AdminOwner.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.01.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct AdminOwner: Equatable {
        var passwordTF: String = ""
        var passwordIsHidden = false
        var premiumIsEnabled = false
        var key = "V1taS"
    }
}
