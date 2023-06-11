//
//  FortuneWheelModel+Configuration.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import RandomUIKit
import UIKit

// MARK: - Configuration

extension FortuneWheelModel {
  
  /// Конфигурация колеса
  var configuration: SFWConfiguration {
    switch style {
    case .regular:
      let pin = SFWConfiguration.PinImageViewPreferences(size: CGSize(width: 30, height: 50),
                                                         position: .top,
                                                         verticalOffset: -30)
      let spin = SFWConfiguration.SpinButtonPreferences(size: CGSize(width: 64, height: 64))
      
      let sliceColorType = SFWConfiguration.ColorType.customPatternColors(colors: wheelColors,
                                                                          defaultColor: .red)
      
      let slicePreferences = SFWConfiguration.SlicePreferences(
        backgroundColorType: sliceColorType,
        strokeWidth: 1,
        strokeColor: .randomColor.only.primaryWhite
      )
      
      let circlePreferences = SFWConfiguration.CirclePreferences(
        strokeWidth: 5,
        strokeColor: .randomColor.only.primaryGreen
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
                                           pinPreferences: pin,
                                           spinButtonPreferences: spin)
      return configuration
    }
  }
}
