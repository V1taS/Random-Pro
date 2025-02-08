//
//  UIColor+Hex.swift
//
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import UIKit

public extension UIColor {
  convenience init(hexString: String) {
    var r: CGFloat = .zero
    var g: CGFloat = .zero
    var b: CGFloat = .zero
    var a: CGFloat = 1
    
    let hexColor = hexString.replacingOccurrences(of: "#", with: "")
    let scanner = Scanner(string: hexColor)
    var hexNumber: UInt64 = 0
    var valid = false
    
    if scanner.scanHexInt64(&hexNumber) {
      if hexColor.count == 8 {
        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        a = CGFloat(hexNumber & 0x000000ff) / 255
        valid = true
      }
      else if hexColor.count == 6 {
        r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
        g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
        b = CGFloat(hexNumber & 0x0000ff) / 255
        valid = true
      }
    }
    
#if DEBUG
    assert(valid, "UIColor initialized with invalid hex string")
#endif
    
    self.init(red: r, green: g, blue: b, alpha: a)
  }
}
