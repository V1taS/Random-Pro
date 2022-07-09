//
//  YesOrNo.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 SosinVitalii.com. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct YesOrNo: Equatable {
        var result: String = "?"
        var listYesOrNo = [NSLocalizedString("Да", comment: ""), NSLocalizedString("Нет", comment: "")]
        var listResult: [String] = []
        var showSettings = false
    }
}
