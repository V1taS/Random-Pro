//
//  Color+DynamicProvider.swift
//  FancyStyle
//
//  Created by Vitalii Sosin on 09.09.2023.
//

import SwiftUI

extension Color {
  init(light: ColorToken, dark: ColorToken? = nil) {
    self.init(UIColor(light: light, dark: dark))
  }
  
  init(_ uiColor: UIColor) {
    self.init(red: uiColor.redValue, green: uiColor.greenValue, blue: uiColor.blueValue, opacity: uiColor.alphaValue)
  }
}

extension UIColor {
  var redValue: Double {
    return CIColor(color: self).red
  }
  
  var greenValue: Double {
    return CIColor(color: self).green
  }
  
  var blueValue: Double {
    return CIColor(color: self).blue
  }
  
  var alphaValue: Double {
    return CIColor(color: self).alpha
  }
}
