//
//  FortuneWheelModel+MockSection.swift
//  Random
//
//  Created by Vitalii Sosin on 17.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import FancyUIKit
import FancyStyle
import UIKit

// MARK: - Mock section

extension FortuneWheelModel.MockSection {
  
  /// Низвание секции
  var title: String {
    switch self {
    case .truthOrDare:
      let truth = RandomStrings.Localizable.truth
      let or = RandomStrings.Localizable.or
      let dare = RandomStrings.Localizable.dare
      return "\(truth) \(or) \(dare)"
    case .yesOrNo:
      return RandomStrings.Localizable.yesOrNo
    case .whatColor:
      return RandomStrings.Localizable.whatColor
    }
  }
  
  /// Смайлик секции
  var icon: String? {
    switch self {
    case .truthOrDare:
      return "♥️"
    case .yesOrNo:
      return "❓"
    case .whatColor:
      return "🎨"
    }
  }
  
  /// Объекты
  var objects: [String] {
    switch self {
    case .truthOrDare:
      return [
        RandomStrings.Localizable.truth,
        RandomStrings.Localizable.dare,
        RandomStrings.Localizable.pass
      ]
    case .yesOrNo:
      return [
        RandomStrings.Localizable.yes,
        RandomStrings.Localizable.no
      ]
    case .whatColor:
      return [
        RandomStrings.Localizable.red,
        RandomStrings.Localizable.blue,
        RandomStrings.Localizable.green,
        RandomStrings.Localizable.yellow,
        RandomStrings.Localizable.orange
      ]
    }
  }
}
