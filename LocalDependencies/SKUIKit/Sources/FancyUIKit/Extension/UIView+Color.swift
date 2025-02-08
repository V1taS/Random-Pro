//
//  UIView+Color.swift
//  
//
//  Created by Mikhail Kolkov on 5/3/23.
//

import UIKit

// MARK: - Конвертация UIColor -> #HEX

public extension UIView {
  
  /// Конверовать сгенерированные цвета в формат hex
  /// - Parameters:
  ///  - colors: массив цвет для конвертации
  /// - Returns: массив с hex значениями цветов
  func convertToHex(colors: [UIColor]) -> String {
    var hexArray: [String] = []
    
    for color in colors {
      if let components = color.cgColor.components, components.count == 4 {
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let hex = String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        hexArray.append(hex)
      }
    }
    let hexString = hexArray.joined(separator: "\n")
    return hexString
  }
}
