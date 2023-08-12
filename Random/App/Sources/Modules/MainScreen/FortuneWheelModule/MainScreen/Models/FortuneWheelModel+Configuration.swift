//
//  FortuneWheelModel+Configuration.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import FancyUIKit
import FancyStyle
import UIKit

// MARK: - Configuration

extension FortuneWheelModel {
  
  /// Конфигурация колеса
  var configuration: SFWConfiguration {
    switch style {
    case .regular:
      let spin = SFWConfiguration.SpinButtonPreferences(size: CGSize(width: 100, height: 100))
      
      let sliceColorType = SFWConfiguration.ColorType.customPatternColors(colors: nil,
                                                                          defaultColor: .clear)
      
      let slicePreferences = SFWConfiguration.SlicePreferences(
        backgroundColorType: sliceColorType,
        strokeWidth: 1,
        strokeColor: fancyColor.only.primaryWhite
      )
      
      let circlePreferences = SFWConfiguration.CirclePreferences(
        strokeWidth: 5,
        strokeColor: fancyColor.only.primaryGreen
      )
      var wheelPreferences = SFWConfiguration.WheelPreferences(circlePreferences: circlePreferences,
                                                               slicePreferences: slicePreferences,
                                                               startPosition: .top)
      let anchorImage = SFWConfiguration.AnchorImage(
        imageName: RandomAsset.fortuneWheelAnchor.name,
        size: CGSize(width: 8, height: 8),
        verticalOffset: 0
      )
      wheelPreferences.imageAnchor = anchorImage
      let configuration = SFWConfiguration(wheelPreferences: wheelPreferences,
                                           spinButtonPreferences: spin)
      return configuration
    }
  }
}
