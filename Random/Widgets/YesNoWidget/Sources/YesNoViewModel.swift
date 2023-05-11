//
//  YesNoModel.swift
//  Random
//
//  Created by Nikita Ivlev on 8/5/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

final class YesNoViewModel: ObservableObject {
  @Published var result: String = ""
  
  func generateResult() {
    let answers = [YesNoWidgetStrings.yes,
                   YesNoWidgetStrings.no]
    let randomIndex = Int.random(in: 0..<answers.count)
    result = answers[randomIndex]
  }
}
