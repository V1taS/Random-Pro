//
//  FortuneWheelModel+Slices.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import FancyUIKit
import FancyStyle
import UIKit

// MARK: - Slices

extension FortuneWheelModel {
  
  /// Данные для отображения
  var slices: [Slice] {
    switch style {
    case .regular:
      guard let selectedSection = sections.filter({ $0.isSelected }).first else {
        return []
      }
      var objects: [(String, Int)] = []
      
      if selectedSection.objects.count > .zero && selectedSection.objects.count <= 3 {
        objects = Array(
          repeating: selectedSection.objects.compactMap(\.text),
          count: 3
        ).flatMap {
          $0
        }.enumerated().map {
          ($1, $0 % selectedSection.objects.count)
        }
        
      } else if selectedSection.objects.count > 3 && selectedSection.objects.count < 5 {
        objects = Array(
          repeating: selectedSection.objects.compactMap(\.text),
          count: 2
        ).flatMap {
          $0
        }.enumerated().map {
          ($1, $0 % selectedSection.objects.count)
        }
      } else {
        objects = selectedSection.objects.compactMap(\.text).enumerated().map {
          ($1, $0)
        }
      }
      
      return objects.compactMap { object, originalIndex in
        var slice = Slice(contents: [
          .text(text: object, preferences: titlePreferences)
        ])
        
        let colorIndex = originalIndex % wheelColors.count
        slice.backgroundColor = wheelColors[colorIndex]
        return slice
      }
    }
  }
}
