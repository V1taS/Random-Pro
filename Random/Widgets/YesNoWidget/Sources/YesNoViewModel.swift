//
//  YesNoModel.swift
//  Random
//
//  Created by Nikita Ivlev on 8/5/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

class YesNoViewModel: ObservableObject {
    @Published var result: String = ""

    func generateResult() {
        let answers = ["yes", "no"]
        let randomIndex = Int.random(in: 0..<answers.count)
        result = NSLocalizedString(answers[randomIndex], comment: "")
    }
}
