//
//  UIColor+DynamicProvider.swift
//
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit

extension UIColor {
  convenience init(light: ColorToken, dark: ColorToken? = nil) {
    guard #available(iOS 13.0, *), let dark = dark else {
      self.init(hexString: light.hexString)
      return
    }
    
    let lightColor = UIColor(hexString: light.hexString)
    let darkColor = UIColor(hexString: dark.hexString)
    
    self.init(dynamicProvider: {
      switch $0.userInterfaceStyle {
      case .light: return lightColor
      case .dark: return darkColor
      case .unspecified:
        fallthrough
      @unknown default:
        return lightColor
      }
    })
  }
}
