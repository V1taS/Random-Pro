//
//  FortuneWheelModel+Slices.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import RandomUIKit
import UIKit

// MARK: - Slices

extension FortuneWheelModel {
  
  /// Данные для отображения
  var slices: [Slice] {
    switch style {
    case .regular:
      let objects = selectedSection.objects
      return objects.compactMap {
        Slice(contents: [
          .text(text: $0.title, preferences: titlePreferences)
        ])
      }
    }
  }
}
