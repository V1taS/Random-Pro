//
//  Color+UIColor.swift
//
//
//  Created by Vitalii Sosin on 10.12.2023.
//

import SwiftUI

public extension Color {
  var uiColor: UIColor {
    if #available(iOS 14.0, *) {
      return UIColor(self)
    } else {
      let components = self.components()
      return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
  }
  
  private func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
    var hexNumber: UInt64 = 0
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    
    let result = scanner.scanHexInt64(&hexNumber)
    if result {
      r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
      g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
      b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
      a = CGFloat(hexNumber & 0x000000ff) / 255
    }
    return (red: r, green: g, blue: b, alpha: a)
  }
}
